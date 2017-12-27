defmodule Gringotts.Gateways.WireCardTest do
  use ExUnit.Case, async: false

  import Mock

  alias Gringotts.{
    CreditCard,
  }

  alias Gringotts.Gateways.WireCard, as: Gateway

  @with authorization_guwid "C822580121385121429927"
  @with purchase_guwid      "C865402121385575982910"
  @with capture_guwid       "C833707121385268439116"

  @card %CreditCard{
    number: "4200000000000000",
    month: 12,
    year: 2018,
    first_name: "Longbob",
    last_name: "Longsen",
    verification_code: "123",
    brand: "visa"
  }

  @declined_card %CreditCard{
    number: "4000300011112220",
    month: 12,
    year: 2018,
    first_name: "Longbob",
    last_name: "Longsen",
    verification_code: "123",
    brand: "visa"
  }

  @address %{
    name:     "Jim Smith",
    address1: "456 My Street",
    address2: "Apt 1",
    company:  "Widgets Inc",
    city:     "Ottawa",
    state:    "ON",
    zip:      "K1C2N6",
    country:  "CA",
    phone:    "(555)555-5555",
    fax:      "(555)555-6666"
  }

  @options [
    order_id: 1,
    billing_address: @address,
    description: 'Wirecard remote test purchase',
    email: "soleone@example.com",
    ip: "127.0.0.1",
    test: true
  ]

  describe "authorize/3" do
    @tag :pending
    test "with successful authorization" do
    end

    @tag :pending
    test "with successful reference authorization" do
    end

    @tag :pending
    test "with wrong credit card authorization" do      
    end
  end

  describe "purchase/3" do
    @tag :pending
    test "with successful purchase" do
    end

    @tag :pending
    test "with successful reference purchase" do
    end
  end

  describe "authorize/3 and capture/3" do
    @tag :pending
    test "with successful authorization and capture" do
    end

    @tag :pending
    test "with successful authorization and partial capture" do
    end

    @tag :pending
    test "with unauthorized capture" do  
    end
  end

  describe "refund/3" do
    @tag :pending
    test "with successful refund" do
    end

    @tag :pending
    test "with failed refund" do
    end
  end

  describe "void/2" do
    @tag :pending
    test "with successful void" do
    end

    @tag :pending
    test "with failed void" do
    end
  end

  describe "store/2" do
    @tag :pending
    test "with store sets recurring transaction type to initial" do
    end

    @tag :pending
    test "with store sets amount to 100 by default" do
    end

    @tag :pending
    test "with store sets amount to amount from options" do
    end
  end

  describe "scrubbing/1" do
    @tag :pending
    test "with transcript scrubbing" do
    end
  end

  describe "testing response for different request scenarios" do
    @tag :pending
    test "with no error if no state is provided in address" do
    end

    @tag :pending
    test "with no error if no address provided" do
    end

    @tag :pending
    test "with failed avs response message" do
    end

    @tag :pending
    test "with failed amex avs response code" do
    end

    @tag :pending
    # Not sure what is this need to check
    test "with commerce type option" do
    end

    @tag :pending
    test "with authorization using reference sets proper elements" do
    end
  
    @tag :pending
    test "with purchase using reference sets proper elements" do
    end
  
    @tag :pending
    test "with authorization with recurring transaction type initial" do
    end
  
    @tag :pending
    test "with purchase using with recurring transaction type initial" do
    end

    @tag :pending
    test "with description trucated to 32 chars in authorize" do
    end

    @tag :pending
    test "with description trucated to 32 chars in purchase" do
    end

    @tag :pending
    test "with description is ascii encoded since wirecard does not like utf 8" do 
    end
  end

  describe "system error in response in differnt request scenarios" do
    @tag :pending
    test "with system error response" do      
    end

    @tag :pending
    test "with system error response without job" do      
    end
  end
end
