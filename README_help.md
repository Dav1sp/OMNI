# Ajuda para o Laravel

## DATABASE : Omni_data_base

A base de dados encontra-se na pasta **../resources/sql**.

Foi alterado no ficheiro **DatabaseSeeder.php** a path do caminho de **~~resources/sql/seed.sql~~** para **resources/sql/Omni_data_base.sql**.

Antes de correr o servidor é melhor carregar a base de dados na pgAdmin sempre para isso basta correr a seguinte linha de comandos na shell **php artisan db:seed**.

Para verificar se está tudo bem podemos correr a seguinte linha de comandos na shell **php artisan tinker** e depois **DB::connection()->getPdo();** se for retornado um objeto do tipo **PDO** então está tudo bem, caso contrario deve dar um **pdo_exption**.

## Controllers / Routes

Uso o comando **php artisan make:controller Static/StaticController** para criar os controllers neste caso crio o controller **StaticController** na pasta **Static** acho que o melhor seria dividir em pastas para uma organização melhor.

Os **Routes** são escrtios na no fichierio **web.php** ele está na pasta **../routes/web.php** só fiz as static para já. o namespace contem uma variavel da path que está escrito **../app/http/controllers**

Depois de criar o ficheiro que mencionei em cima escrevi as funções que retornam as **views** elas estão na pasta **../resources/views** neste caso criei tambem um pasta chamada **static** para chamar o ficheiro escrevemos **static.help** o primeiro indica a **pasta** depois do ponto indica o **nome**. para as chamar o ideal é meter **StaticController@help** por exemplo que chama o staticController e corre a função **help**.