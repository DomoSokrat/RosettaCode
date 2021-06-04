import gtk2, glib2, strutils, random

var valu: int = 0
var chngd_txt_hndler: gulong = 0

proc thisDestroy(widget: PWidget, data: Pgpointer) {.cdecl.} =
  main_quit()

randomize()
nim_init()
var win = window_new(gtk2.WINDOW_TOPLEVEL)
var content = vbox_new(true, 10)
var hbox1 = hbox_new(true, 10)
var hbox2 = hbox_new(false, 1)
var lbl = label_new("Value:")
var entry_fld = entry_new()
var btn_quit = button_new("Quit")
var btn_inc = button_new("Increment")
var btn_rnd = button_new("Random")
entry_fld.set_text("0")
hbox2.add(lbl)
hbox2.add(entry_fld)
hbox1.add(btn_inc)
hbox1.add(btn_rnd)
content.pack_start(hbox2, true, true, 0)
content.pack_start(hbox1, true, true, 0)
content.pack_start(btn_quit, true, true, 0)
win.set_border_width(5)
win.add(content)

proc on_question_clicked: bool =
  var dialog = win.message_dialog_new(0, MESSAGE_QUESTION,
    BUTTONS_YES_NO, "Use a Random number?")
  var response = dialog.run()
  dialog.destroy()
  response == RESPONSE_YES

proc thisInc(widget: PWidget, data: Pgpointer){.cdecl.} =
  inc(valu)
  entry_fld.set_text($valu)

proc thisRnd(widget: PWidget, data: Pgpointer){.cdecl.} =
  if on_question_clicked():
    valu = rand(20)
    entry_fld.set_text($valu)

proc thisTextChanged(widget: PWidget, data: Pgpointer) {.cdecl.} =
  #entry_fld.signal_handler_block(chngd_txt_hndler)
  try:
    valu = parseInt($entry_fld.get_text())
  except ValueError:
    valu = 0
  entry_fld.set_text($valu)
  #entry_fld.signal_handler_unblock(chngd_txt_hndler)
  #entry_fld.signal_emit_stop(signal_lookup("changed", TYPE_EDITABLE()), 0)

discard win.signal_connect("destroy", SIGNAL_FUNC(thisDestroy), nil)
discard btn_quit.signal_connect("clicked", SIGNAL_FUNC(thisDestroy), nil)
discard btn_inc.signal_connect("clicked", SIGNAL_FUNC(thisInc), nil)
discard btn_rnd.signal_connect("clicked", SIGNAL_FUNC(thisRnd), nil)
chngd_txt_hndler = entry_fld.signal_connect("changed", SIGNAL_FUNC(thisTextChanged), nil)

win.show_all()
main()
