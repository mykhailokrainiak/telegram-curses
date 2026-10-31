#pragma once

#include "windows/OneLineInputWindow.hpp"
#include <algorithm>
#include <memory>

namespace tdcurses {

class CommandLineWindow : public windows::OneLineInputWindow {
 public:
  class Callback {
   public:
    virtual ~Callback() = default;
    virtual void on_command(std::string command) = 0;
  };

  bool force_active() const override {
    return !is_empty();
  }

 private:
  class Cb : public windows::OneLineInputWindow::Callback {
   public:
    Cb(std::unique_ptr<CommandLineWindow::Callback> cb) : cb_(std::move(cb)) {
    }
    void on_answer(OneLineInputWindow *self, std::string text) override {
      cb_->on_command(std::move(text));
      self->clear();
    }
    void on_abort(OneLineInputWindow *self, std::string text) override {
      self->clear();
    }

   private:
    std::unique_ptr<CommandLineWindow::Callback> cb_;
  };

 public:
  CommandLineWindow(std::unique_ptr<CommandLineWindow::Callback> cb)
      : windows::OneLineInputWindow(" Search / command > ", false, std::make_unique<Cb>(std::move(cb))) {
  }
  void render(windows::WindowOutputter &rb, bool force) override {
    if (!is_empty()) return windows::OneLineInputWindow::render(rb, force);
    rb.erase_rect(0, 0, height(), width());
    rb.set_fg_color(windows::Color::Grey);
    const std::string hints = " Enter Open   s Find   / Filter   i Write   f Folders   Tab Switch pane   F1 Help";
    rb.putstr_yx(0, 0, hints.c_str(), std::min(hints.size(), static_cast<size_t>(width())));
    rb.unset_fg_color();
    rb.cursor_move_yx(0, 0, windows::WindowOutputter::CursorShape::None);
  }
};

}  // namespace tdcurses
