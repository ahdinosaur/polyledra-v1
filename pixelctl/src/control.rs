use std::sync::mpsc::{channel, Sender, Receiver};

pub enum ChangeMode {
    Prev,
    Next
}

pub enum ControlMessage {
    ChangeMode(ChangeMode)
}

pub fn create_control_channel() -> (Sender<ControlMessage>, Receiver<ControlMessage>) {
    return channel();
}


