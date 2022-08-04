<article class="card" data-id="{{ $card->id }}">
<header>
  <h2><a href="/cards/{{ $card->id }}">{{ $card->name }}</a></h2>
  <a href="#" class="delete">&#10761;</a>
</header>
 Noticia bla bla
<form class="new_item">
  <input type="text" name="description" placeholder="new item">
</form>
</article>
