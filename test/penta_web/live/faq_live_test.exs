defmodule PentaWeb.FAQLiveTest do
  use PentaWeb.ConnCase

  import Phoenix.LiveViewTest
  import Penta.FAQsFixtures
  import Penta.AccountsFixtures

  @create_attrs %{answer: "some answer", question: "some question"}
  @update_attrs %{
    answer: "some updated answer",
    question: "some updated question"
  }
  @invalid_attrs %{answer: nil, question: nil}

  defp create_faq(_) do
    faq = faq_fixture()
    %{faq: faq}
  end

  describe "Index" do
    setup [:create_faq]

    test "lists all faqs", %{conn: conn, faq: faq} do
      {:ok, _index_live, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/faqs")

      assert html =~ "Listing Faqs"
      assert html =~ faq.answer
    end

    test "saves new faq", %{conn: conn} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/faqs")

      assert index_live |> element("a", "New Faq") |> render_click() =~
               "New Faq"

      assert_patch(index_live, ~p"/faqs/new")

      assert index_live
             |> form("#faq-form", faq: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#faq-form", faq: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/faqs")

      html = render(index_live)
      assert html =~ "Faq created successfully"
      assert html =~ "some answer"
    end

    test "updates faq in listing", %{conn: conn, faq: faq} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/faqs")

      assert index_live
             |> element(~s(#faqs-#{faq.id} a[id="faqs-edit-#{faq.id}"]))
             |> render_click() =~ "Edit Faq"

      assert_patch(index_live, ~p"/faqs/#{faq}/edit")

      assert index_live
             |> form("#faq-form", faq: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#faq-form", faq: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/faqs")

      html = render(index_live)
      assert html =~ "Faq updated successfully"
      assert html =~ "some updated answer"
    end

    test "deletes faq in listing", %{conn: conn, faq: faq} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/faqs")

      assert index_live
             |> element(~s(#faqs-#{faq.id} a[id="faqs-delete-#{faq.id}"]))
             |> render_click()

      refute has_element?(index_live, "#faqs-#{faq.id}")
    end
  end

  describe "Show" do
    setup [:create_faq]

    test "displays faq", %{conn: conn, faq: faq} do
      {:ok, _show_live, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/faqs/#{faq}")

      assert html =~ "Show Faq"
      assert html =~ faq.answer
    end

    test "updates faq within modal", %{conn: conn, faq: faq} do
      {:ok, show_live, _html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/faqs/#{faq}")

      assert show_live
             |> element("a", "Edit")
             |> render_click() =~
               "Edit Faq"

      assert_patch(show_live, ~p"/faqs/#{faq}/show/edit")

      assert show_live
             |> form("#faq-form", faq: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#faq-form", faq: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/faqs/#{faq}")

      html = render(show_live)
      assert html =~ "Faq updated successfully"
      assert html =~ "some updated answer"
    end
  end
end
