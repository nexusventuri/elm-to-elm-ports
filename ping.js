"use strict";
(function(window) {
   var node = document.getElementById('main');
   var main = Elm.Main.embed(node);

   var subscribers = document.getElementsByClassName('presenter');

   var count = 0;
   console.log('subscribers ', subscribers.length)
   Array.from(subscribers).forEach(function(element) {
     var flags = {
       startingValue: count
     };
     count += 1;

     var subscriber = Elm.Subscriber.embed(element, flags);
     main.ports.toSubscribers.subscribe(function(str) {
       console.log("got from elm:", str);
       subscriber.ports.fromMain.send(str);
     });
   });


   // receive something from Elm
//   main.ports.toJs.subscribe(function (str) {
//      console.log("got from Elm", str);
//      // send something back to Elm
//      var uppercase = undefined;
//      main.ports.toElm.send(uppercase);
//   });
}(window));
