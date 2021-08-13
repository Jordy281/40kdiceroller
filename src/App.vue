<template>
  <v-app>
    <nav class="navbar navbar-dark navbar-expand-lg fixed-top bg-dark navbar-custom">
        <div class="container"><a class="navbar-brand" href="#">Warhammer Easy Button</a><button data-bs-toggle="collapse" class="navbar-toggler" data-bs-target="#navbarResponsive"><span class="visually-hidden">Toggle navigation</span><span class="navbar-toggler-icon"></span></button>
            <div class="collapse navbar-collapse" id="navbarResponsive">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link" href="#">Sign Up</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Log In</a></li>
                </ul>
            </div>
        </div>
    </nav>
    <v-main>
      <router-view/>
    </v-main>
    <footer class="py-5 bg-black">
        <div class="container">
            <p class="text-center text-white m-0 small">Copyright&nbsp;© Warhammer Easy Button 2021</p>
        </div>
    </footer>
  </v-app>
</template>

<script>

export default {
  name: 'App',

  data: () => ({
    //
  })
}
</script>
