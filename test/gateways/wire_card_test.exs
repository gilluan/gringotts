defmodule Gringotts.Gateways.WireCardTest do
  use ExUnit.Case, async: false

  import Mock

  alias Gringotts.{
    CreditCard,
  }

  alias Gringotts.Gateways.WireCard, as: Gateway

  @test_authorization_guwid "C822580121385121429927"
  @test_purchase_guwid      "C865402121385575982910"
  @test_capture_guwid       "C833707121385268439116"

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
    test "test_successful_authorization" do
    end

    @tag :pending
    test "test_successful_reference_authorization" do
    end

    @tag :pending
    test "test_wrong_credit_card_authorization" do      
    end
  end

  describe "purchase/3" do
    @tag :pending
    test "test_successful_purchase" do
    end

    @tag :pending
    test "test_successful_reference_purchase" do
    end
  end

  describe "authorize/3 and capture/3" do
    @tag :pending
    test "test_successful_authorization_and_capture" do
    end

    @tag :pending
    test "test_successful_authorization_and_partial_capture" do
    end

    @tag :pending
    test "test_unauthorized_capture" do  
    end
  end

  describe "refund/3" do
    @tag :pending
    test "test_successful_refund" do
    end

    @tag :pending
    test "test_failed_refund" do
    end
  end

  describe "void/2" do
    @tag :pending
    test "test_successful_void" do
    end

    @tag :pending
    test "test_failed_void" do
    end
  end

end
