defmodule Gringotts.Gateways.Trexle do
  
  @moduledoc """
  TREXLE PAYMENT GATEWAY IMPLEMENTATION:

  For further details, please refer [Trexle API documentation](https://docs.trexle.com/).

  Following are the features that have been implemented for the Trexle Gateway:

  | Action                       | Method        |
  | ------                       | ------        |
  | Authorize                    | `authorize/3` |
  | Purchase                     | `purchase/3`  |
  | Capture                      | `capture/3`   |
  | Refund                       | `refund/3`    |
  | Store                        | `store/2`     |

  ## The `opts` argument
  A `Keyword` list `opts` passed as an optional argument for transactions with the gateway. Following are the keys
  supported:

  * email
  * ip_address
  * description
  
  ## Trexle account registeration with `Gringotts`
  After creating your account successfully on [Trexle](https://docs.trexle.com/) follow the [dashboard link](https://trexle.com/dashboard/api-keys) to fetch the secret api_key.
  
  Your Application config must look something like this:
  
      config :gringotts, Gringotts.Gateways.Trexle,
          adapter: Gringotts.Gateways.Trexle,
          api_key: "Secret API key",
          default_currency: "USD"
  """

  @base_url "https://core.trexle.com/api/v1/"

  alias Gringotts.Gateways.Trexle.ResponseHandler, as: ResponseParser
  use Gringotts.Gateways.Base
  use Gringotts.Adapter, required_config: [:api_key, :default_currency]

  @doc """
  Authorizes your card with the given amount and returns a charge token and captured status as false in response.

  ### Example
  ```
  iex> amount = 100
  
  iex> card = %{
    name: "John Doe",
    number: "5200828282828210",
    expiry_month: 1,
    expiry_year: 2018,
    cvc:  "123",
    address_line1: "456 My Street",
    address_city: "Ottawa",
    address_postcode: "K1C2N6",
    address_state: "ON",
    address_country: "CA"
  }
  
  iex> options = [email: "john@trexle.com", ip_address: "66.249.79.118" , description: "Store Purchase 1437598192"]
  
  iex> Gringotts.authorize(:payment_worker, Gringotts.Gateways.Trexle, amount, card, options)
  ```
  """

  @spec authorize(float, map, list) :: map
  def authorize(amount, payment, opts \\ []) do
    params = create_params_for_auth_or_purchase(amount, payment, opts, false)
    commit(:post, "charges", params, opts)
  end

  @doc """
  Performs the amount transfer from the customer to the merchant.

  The actual amount deduction performed by Trexle using the customer's card info.

  ## Example
  ```
  iex> card = %{
    name: "John Doe",
    number: "5200828282828210",
    expiry_month: 1,
    expiry_year: 2018,
    cvc:  "123",
    address_line1: "456 My Street",
    address_city: "Ottawa",
    address_postcode: "K1C2N6",
    address_state: "ON",
    address_country: "CA"
  }

  iex> options = [email: "john@trexle.com", ip_address: "66.249.79.118" ,description: "Store Purchase 1437598192"]
  
  iex> amount = 50  
  
  iex> Gringotts.purchase(:payment_worker, Gringotts.Gateways.Trexle, amount, card, options)
  ```
  """

  @spec purchase(float, map, list) :: map
  def purchase(amount, payment, opts \\ []) do
    params = create_params_for_auth_or_purchase(amount, payment, opts)
    commit(:post, "charges", params, opts)
  end
  
  @doc """
  Captures a particular amount using the charge token of a pre authorized card.

  The amount specified should be less than or equal to the amount given prior to capture while authorizing the card. 
  If the amount mentioned is less than the amount given in authorization process, the mentioned amount is debited.
  Please note that multiple captures can't be performed for a given charge token from the authorisation process. 

  ### Example
  ```
  iex> amount = 100

  iex> token = "charge_6a5fcdc6cdbf611ee3448a9abad4348b2afab3ec"

  iex> Gringotts.capture(:payment_worker, Gringotts.Gateways.Trexle, token, amount)
  ```
  """

  @spec capture(String.t, float, list) :: map
  def capture(charge_token, amount, opts \\ []) do
    params = [amount: amount]
    commit(:put, "charges/#{charge_token}/capture", params, opts)
  end

  @doc """
  Refunds the amount to the customer's card with reference to a prior transfer.

  Trexle processes a full or partial refund worth `amount`,referencing a
  previous `purchase/3` or `capture/3`.

  Multiple refund can be performed for the same charge token from purchase or capture done before performing refund action unless the cumulative amount is less than the amount given while authorizing. 

  ## Example
  The following session shows how one would refund a previous purchase (and similarily for captures).
  ```      
  iex> amount = 5

  iex> token = "charge_668d3e169b27d4938b39246cb8c0890b0bd84c3c"

  iex> options = [email: "john@trexle.com", ip_address: "66.249.79.118" , description: "Store Purchase 1437598192"]

  iex> Gringotts.refund(:payment_worker, Gringotts.Gateways.Trexle, amount, token, options)
  ```
  """ 

  @spec refund(float, String.t, list) :: map 
  def refund(amount, charge_token, opts \\ []) do
    params = [amount: amount]
    commit(:post, "charges/#{charge_token}/refunds", params, opts)
  end

  @doc """
  Stores the card info for future use.

  ## Example
  The following session shows how one would store a card (a payment-source) for future use.
  ```
  iex> card = %{
    name: "John Doe",
    number: "5200828282828210",
    expiry_month: 1,
    expiry_year: 2018,
    cvc:  "123",
    address_line1: "456 My Street",
    address_city: "Ottawa",
    address_postcode: "K1C2N6",
    address_state: "ON",
    address_country: "CA"
  }

  iex> options = [email: "john@trexle.com", ip_address: "66.249.79.118" , description: "Store Purchase 1437598192"]
  
  iex> Gringotts.store(:payment_worker, Gringotts.Gateways.Trexle, card, options)
  ```
  """

  @spec store(map, list) :: map
  def store(payment, opts \\ []) do
    params = [email: opts[:email]] ++ card_params(payment)
    commit(:post, "customers", params, opts)
  end

  defp create_params_for_auth_or_purchase(amount, payment, opts, capture \\ true) do
    [
      capture: capture,
      amount: amount,
      currency: opts[:config][:default_currency],
      email: opts[:email],
      ip_address: opts[:ip_address],
      description: opts[:description]
    ] ++ card_params(payment)
  end

  defp card_params(%{} = card) do
    [ 
      "card[name]": card[:name],
      "card[number]": card[:number],
      "card[expiry_year]": card[:expiry_year],
      "card[expiry_month]": card[:expiry_month],
      "card[cvc]": card[:cvc],
      "card[address_line1]": card[:address_line1],
      "card[address_city]": card[:address_city],
      "card[address_postcode]": card[:address_postcode],
      "card[address_state]": card[:address_state],
      "card[address_country]": card[:address_country]
    ]   
  end

  defp commit(method, path, params \\ [], opts \\ []) do
    auth_token = "Basic #{Base.encode64(opts[:config][:api_key])}"
    headers = [{"Content-Type", "application/x-www-form-urlencoded"}, {"Authorization", auth_token}]
    data = params_to_string(params)
    options = [hackney: [basic_auth: {opts[:config][:api_key], "password"}]]
    url = "#{@base_url}/#{path}"
    response = HTTPoison.request!(method, url, data, headers, options)
    format_response(response)
  end

  defp format_response(response) do
    case {:ok, response} do
      {:ok, %HTTPoison.Response{status_code: 201}} -> {:ok, response}
      {:ok, %HTTPoison.Response{status_code: 200}} -> {:ok, response}
      {:ok, %HTTPoison.Response{status_code: 400}} -> {:error, response}
      {:ok, %HTTPoison.Response{status_code: 401}} -> {:error, response}
      _ -> %{"error" => "something went wrong, please try again later"}
    end
  end

end