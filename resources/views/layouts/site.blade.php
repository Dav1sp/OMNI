<!DOCTYPE html>
<html>
    <head>
    <title>OMNIS</title>
        <base href="/">
        <meta charset='UTF-8'>
        <meta name="csrf-token" content="{{ csrf_token() }}">
        <link id="favicon" rel= "shotcut icon" href="../img/icons/NewLogo.png" sizes="96x96" type="image/png">
        <link href='https://fonts.googleapis.com/css?family=Red Hat Display' rel='stylesheet'>
        <!--links-->
        <link rel="stylesheet" href="css/navBar.css">
        <link rel="stylesheet" href="css/static.css">
        <link rel="stylesheet" href="css/post.css">
        <link rel="stylesheet" href="css/admin.css">
        <link rel="stylesheet" href="css/auth.css">
        <link rel="stylesheet" href="css/profile.css">
    </head>
    <body>
        <div class="navbar">
           <div class="Logo">
                <a href="/"><img src="img/icons/NewLogoName.png" class="logoImg"></a>
            </div>
            <div class=Search>
                <form action="/" method="GET" class= Search-form>
                    <input type="text" id ="search"  name = "search" placeholder="Search for News or Topics..">
                </form>

            </div>
            <div class="ProfileOrNotify">
                <div class=loginProfile>
                    @if(session()->has('usuario'))
                        <a href="../Logout" class=button>
                                    <span></span>
                                    <span></span>
                                    <span></span>
                                    <span></span>
                                    Logout
                        </a>

                        <a href="/profile/{{session('usuario')->id_users}}"class = ProfileImage>
                            @if( session('usuario')->photo === '../img/icons/user.png')

                                <img src="{{session('usuario')->photo}}" class="ProfileImage">
                            @else
                                <img src= "img/profiles/{{session('usuario')->photo}}" style="border-radius: 50%" class="ProfileImage">
                            @endif


                        </a>
                    @else
                        @guest
                        <a href="../Register"class=button>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                Register
                        </a>
                        <a href="../Login"class=button>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                Login
                        </a>
                        @endguest
                    @endif
                </div>
            </div>
        </div>
        @yield('content')
        <div class=Pages>
            <a href="../AboutUs">
                <span></span>
                <span></span>
                <span></span>
                <span></span>
                About Us
            </a>
            <a href="../FAQ">
                <span></span>
                <span></span>
                <span></span>
                <span></span>
                FAQ's
            </a>
            <a href="../Contact">
                <span></span>
                <span></span>
                <span></span>
                <span></span>
                Contact Us
            </a>
            <a href="../Help">
                <span></span>
                <span></span>
                <span></span>
                <span></span>
                Help
            </a>
            @if(session()->has('usuario'))
                @if(session('usuario')->admin == 'true')
                    <a href="../Admin">
                        <span></span>
                        <span></span>
                        <span></span>
                        <span></span>
                        Admin
                    </a>
                @endif
            @endif
        </div>

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js" type="text/javascript"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.form/4.3.0/jquery.form.min.js"></script>

        <script src= "/js/static.js">    </script>
        <script src= "/js/like.js"  >    </script>
        <script src= "/js/admin.js"  >    </script>
        <script src= "/js/follow.js"  >    </script>
    </body>
</html>
