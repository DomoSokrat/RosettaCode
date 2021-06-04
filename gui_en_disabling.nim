import gtk2, strutils, glib2

var valu: int = 0
var chngd_txt_hndler: gulong = 0

proc thisDestroy(widget: PWidget, data: Pgpointer){.cdecl.} =
  main_quit()

nim_init()
var window = window_new(gtk2.WINDOW_TOPLEVEL)
var content = vbox_new(true, 10)
var hbox1 = hbox_new(true, 10)
var entry_fld = entry_new()
var btn_quit = button_new("Quit")
var btn_inc = button_new("Increment")
var btn_dec = button_new("Decrement")
entry_fld.set_text("0")
hbox1.add(btn_inc)
hbox1.add(btn_dec)
content.pack_start(entry_fld, true, true, 0)
content.pack_start(hbox1, true, true, 0)
content.pack_start(btn_quit, true, true, 0)
window.set_border_width(5)
window.add(content)

proc thisCheckBtns() =
  btn_inc.set_sensitive(valu < 10)
  btn_dec.set_sensitive(valu > 0)
  entry_fld.set_sensitive(valu == 0)

proc thisInc(widget: PWidget, data: Pgpointer){.cdecl.} =
  inc valu
  entry_fld.set_text($valu)
  thisCheckBtns()

proc thisDec(widget: PWidget, data: Pgpointer){.cdecl.} =
  dec valu
  entry_fld.set_text($valu)
  thisCheckBtns()

proc thisTextChanged(widget: PWidget, data: Pgpointer) {.cdecl.} =
  #entry_fld.signal_handler_block(chngd_txt_hndler)
  try:
     valu = parseInt($entry_fld.get_text())
  except ValueError:
     valu = 0
  entry_fld.set_text($valu)
  #entry_fld.signal_handler_unblock(chngd_txt_hndler)
  #entry_fld.signal_emit_stop(signal_lookup("changed", TYPE_EDITABLE()), 0)
  thisCheckBtns()

discard window.signal_connect("destroy", SIGNAL_FUNC(thisDestroy), nil)
discard btn_quit.signal_connect("clicked", SIGNAL_FUNC(thisDestroy), nil)
discard btn_inc.signal_connect("clicked", SIGNAL_FUNC(thisInc), nil)
discard btn_dec.signal_connect("clicked", SIGNAL_FUNC(thisDec), nil)
chngd_txt_hndler = entry_fld.signal_connect("changed", SIGNAL_FUNC(thisTextChanged), nil)

show_all(window)
thisCheckBtns()
main()
