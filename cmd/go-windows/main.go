package main

import (
	"fyne.io/fyne/v2"
	"fyne.io/fyne/v2/app"
  "fyne.io/fyne/v2/driver/desktop"
	"fyne.io/fyne/v2/container"
	"fyne.io/fyne/v2/widget"
)

func main() {
	a := app.New()
	w := a.NewWindow("Window with system tray")


  if desk, ok := a.(desktop.App); ok {
    m := fyne.NewMenu("MyApp",
      fyne.NewMenuItem("Show", func() {
        w.Show()
      }))
    desk.SetSystemTrayMenu(m)
  }

	hello := widget.NewLabel("Hello Fyne!")
	w.SetContent(container.NewVBox(
		hello,
		widget.NewButton("Hi!", func() {
			hello.SetText("Welcome :)")
		}),
	))
  w.SetCloseIntercept(func() {
    w.Hide()
  })

	w.ShowAndRun()
}
