require '../lib/adventure.rb'

ae = AdventureEngine.build("The pirates adventure") {
  dialog(0, "Hello, my friend. You think you are a pirate. But, I don't think you are. Are you ready for a test?") {
    answer 1, "Of course I'm ready for a test, you fool!"
    answer 2, "Well, I'm not sure. I'm a shy guy. I mean... oh, nothing."
    answer 3, "Rakataka, blamblambeee riujoooo"
  }

  dialog(1, "Oh, you are agressive! But that's not all, poor idiot! You need to demostrate you are a real pirate. Come with me.") {
    answer 4, "Ok"
  }

  dialog(2, "I knew it. You are not a real pirate. Get out of my view, asshole!") {
    game_over!
  }

  dialog(3, "OH MY GOD, YOU ARE A REAL PIRATE! Only real pirates are so drunk before abording to the ship. Come with me! And enjoy the ride, boy") {
    answer 4, "Ok"
  }

  dialog(4, "This is just a test for the Adventure Engine so.. you loose because this is a demo!") {
    game_over!
  }
}

ae.start(0)
