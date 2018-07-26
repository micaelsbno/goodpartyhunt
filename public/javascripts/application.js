function findLocation(event){
  event.preventDefault();
  navigator.geolocation.getCurrentPosition(function(position){ 
    var form = document.getElementById('search-form')
    form.action = '/location'
    form.method = 'post'
    var method = document.createElement('input')
    method.name = '_method'
    method.value = 'put'
    var latitude = document.createElement('input')
    latitude.name = 'latitude'
    latitude.value = position.coords.latitude
    var longitude = document.createElement('input')
    longitude.name = 'longitude'
    longitude.value = position.coords.longitude
    form.appendChild(method)
    form.appendChild(latitude)
    form.appendChild(longitude)
    form.submit()
  })
}
  button = document.getElementById('search-location')
  button.addEventListener('click', findLocation)