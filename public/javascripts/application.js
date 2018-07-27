function findLocation(event){
  event.preventDefault();
  navigator.geolocation.getCurrentPosition(function(position){ 
    var form = document.getElementById('search-form')
    form.action = '/location'
    form.method = 'post'
    var method = document.createElement('input')
    method.type = 'hidden'
    method.name = '_method'
    method.value = 'put'
    var latitude = document.createElement('input')
    latitude.type = 'hidden'
    latitude.name = 'latitude'
    latitude.value = position.coords.latitude
    var longitude = document.createElement('input')
    longitude.type = 'hidden'
    longitude.name = 'longitude'
    longitude.value = position.coords.longitude
    form.appendChild(method)
    form.appendChild(latitude)
    form.appendChild(longitude)
    form.submit()
  })
}

button = document.getElementById('search-form')
button.addEventListener('click', findLocation)


function closeMenu(){
  document.querySelector('.show').className = 'hidden'
}

function openMenu(){
  document.querySelector('.hidden').className = 'show'
}

document.querySelector('.menu').addEventListener('click', openMenu)

document.querySelector('.fa-times').addEventListener('click', closeMenu)