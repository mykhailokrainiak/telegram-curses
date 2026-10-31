#pragma once
#include "windows/EmptyWindow.hpp"
#include "windows/Output.hpp"
#include <algorithm>
#include <string>

namespace tdcurses {
class WelcomeWindow : public windows::EmptyWindow {
 public:
  void render(windows::WindowOutputter &rb, bool force) override {
    rb.erase_rect(0, 0, height(), width());
    rb.cursor_move_yx(0, 0, windows::WindowOutputter::CursorShape::None);
    const auto top = std::max(0, height() / 2 - 5);
    auto line = [&](int offset, std::string text, windows::Color color) {
      if (top + offset >= height() || width() < 6) return;
      text.resize(std::min(text.size(), static_cast<size_t>(width() - 4)));
      rb.set_fg_color(color);
      rb.putstr_yx(top + offset, std::max(0, (width() - static_cast<int>(text.size())) / 2), text.c_str(), text.size());
      rb.unset_fg_color();
    };
    rb.set_bold(true);
    line(0, "Your conversations, one key away", windows::Color::White);
    rb.unset_bold();
    line(2, "Choose a chat on the left and press Enter", windows::Color::Silver);
    line(4, "s  Find a conversation", windows::Color::Aqua);
    line(5, "f  Browse your folders", windows::Color::Aqua);
    line(6, "F1  See all keyboard shortcuts", windows::Color::Aqua);
    line(8, "Tab switches panes  |  i starts a message", windows::Color::Grey);
  }
};
}  // namespace tdcurses
