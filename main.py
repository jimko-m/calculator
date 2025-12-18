import flet as ft


def main(page: ft.Page):
    page.title = "Calculator App"
    page.padding = 10
    page.horizontal_alignment = ft.CrossAxisAlignment.CENTER
    page.theme_mode = ft.ThemeMode.DARK

    page.theme = ft.Theme(
        color_scheme=ft.ColorScheme(
            primary=ft.Colors.BLUE_400,
            secondary=ft.Colors.ORANGE_400,
        )
    )

    # عرض العملية
    expression = ft.TextField(
        value="",
        read_only=True,
        text_align=ft.TextAlign.RIGHT,
        text_size=18,
        expand=True,
        border_radius=8,
    )

    # عرض النتيجة
    display = ft.TextField(
        value="",
        read_only=True,
        text_align=ft.TextAlign.RIGHT,
        text_size=28,
        expand=True,
        bgcolor=ft.Colors.BLACK,
        color=ft.Colors.WHITE,
        border_radius=10,
    )

    def on_button_click(e):
        value = e.control.data

        if value in ["+", "*", "/", "%"] and expression.value == "":
            return

        if value == "C":
            expression.value = ""
            display.value = ""

        elif value == "⌫":
            expression.value = expression.value[:-1]

        elif value == "%":
            import re
            match = re.search(r"(\d+\.?\d*)$", expression.value)
            if match:
                number = match.group(1)
                expression.value = expression.value[:-len(number)] + str(float(number)/100)

        elif value == "=":
            try:
                display.value = str(eval(expression.value))
            except Exception:
                display.value = "Error"

        else:
            expression.value += value

        page.update()

    def btn(label, bg, fg=ft.Colors.WHITE):
        return ft.Container(
            content=ft.Text(label, size=20, color=fg),
            alignment=ft.alignment.center,
            bgcolor=bg,
            border_radius=12,
            expand=True,
            height=60,
            data=label,
            on_click=on_button_click,
        )

    def row(buttons):
        return ft.Row(buttons, expand=True, spacing=8)

    page.add(
        expression,
        display,
        row([btn("%", ft.Colors.GREY_700), btn("7", ft.Colors.GREY_800), btn("8", ft.Colors.GREY_800), btn("9", ft.Colors.GREY_800)]),
        row([btn("/", ft.Colors.ORANGE_400), btn("4", ft.Colors.GREY_800), btn("5", ft.Colors.GREY_800), btn("6", ft.Colors.GREY_800)]),
        row([btn("*", ft.Colors.ORANGE_400), btn("1", ft.Colors.GREY_800), btn("2", ft.Colors.GREY_800), btn("3", ft.Colors.GREY_800)]),
        row([btn("-", ft.Colors.ORANGE_400), btn("0", ft.Colors.GREY_800), btn("00", ft.Colors.GREY_800), btn(".", ft.Colors.GREY_800)]),
        row([btn("+", ft.Colors.ORANGE_400), btn("⌫", ft.Colors.GREY_700), btn("C", ft.Colors.RED_400), btn("=", ft.Colors.BLUE_400)]),
    )


ft.app(target=main)