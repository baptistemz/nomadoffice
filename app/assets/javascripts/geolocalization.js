var myPosition = new Array();

$(document).ready(function() {
   $("#geoloc").click(function() {
     navigator.geolocation.getCurrentPosition(
             onSuccess,
             onError, {
                 enableHighAccuracy: true,
                 timeout: 20000,
                 maximumAge: 120000
             }
     );
     function onSuccess(position) {
         myPosition[0] = position.coords.latitude;
         myPosition[1] = position.coords.longitude;
     }

      function onError(err) {
         var message;
         switch (err.code) {
         case 0:
           message = 'Unknown error: ' + err.message;
           break;
         case 1:
           message = 'You denied permission to retrieve a position.';
           break;
         case 2:
           message = 'The browser was unable to determine a position: ' + error.message;
           break;
         case 3:
           message = 'The browser timed out before retrieving the position.';
           break;
         }
      }

      console.log(myPosition)
      $.ajax({
        type: "GET",
        url: 'companies',
        // dataType:"json",
        data: 'lat=' + myPosition[0] +'&lon=' + myPosition[1]
      })
      window.location = 'companies/'+'?lat=' + myPosition[0] +'&lon=' + myPosition[1];
   });
});

