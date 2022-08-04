if(document.getElementById('Users')!=null){
  document.getElementById('Users').onclick=function(){
    if(this.checked){
      //unchecked all toggless
      document.getElementById('Posts').checked=false;
      document.getElementById('Comments').checked=false;
      document.getElementById('Contact').checked=false;
      document.getElementById('Help').checked=false;
      escreverUser();
    }
    else{
      removeTable();
    }
    return;
  }
}
if(document.getElementById('Posts')!=null){
  document.getElementById('Posts').onclick=function(){
    if(this.checked){
      document.getElementById('Users').checked=false;
      document.getElementById('Comments').checked=false;
      document.getElementById('Contact').checked=false;
      document.getElementById('Help').checked=false;
      escreverPost();
    }
    else{
      document.getElementById("table").remove();
    }
    return;
  }
}
if(document.getElementById('Comments')!=null){
  document.getElementById('Comments').onclick=function(){
    if(this.checked){
      document.getElementById('Users').checked=false;
      document.getElementById('Posts').checked=false;
      document.getElementById('Contact').checked=false;
      document.getElementById('Help').checked=false;
      escreverComments();
    }
    else{
      removeTable();
    }
    return;
  }
}
if(document.getElementById('Contact')!=null){
  document.getElementById('Contact').onclick=function(){
    if(this.checked){
      document.getElementById('Users').checked=false;
      document.getElementById('Posts').checked=false;
      document.getElementById('Comments').checked=false;
      document.getElementById('Help').checked=false;
      escreverContact();
    }
    else{
      removeTable();
    }
    return;
  }
}
if(document.getElementById('Help')!=null){
  document.getElementById('Help').onclick=function(){
    if(this.checked){
      document.getElementById('Users').checked=false;
      document.getElementById('Posts').checked=false;
      document.getElementById('Comments').checked=false;
      document.getElementById('Contact').checked=false;
      escreverHelp();
    }
    else{
      removeTable();
    }
    return;
  }
}

function removeTable(){
  if(document.getElementById("table")!=null){
    document.getElementById("table").remove();
  }
}

function escreverUser(){
  removeTable();

  $.ajax({
    url:"/Admin/User",
    type: "get",
    dataType: 'json',
    success: function(response){
        let table = document.createElement('table');
        table.id='table';
        let thead = document.createElement('thead');
        let tbody = document.createElement('tbody');
        table.appendChild(thead);
        table.appendChild(tbody);
        document.getElementById("admin-conteudo").appendChild(table);
        let row_1 = document.createElement('tr');
        let heading_1 = document.createElement('th');
        heading_1.innerHTML = "id_users";
        let heading_2 = document.createElement('th');
        heading_2.innerHTML = "email";
        let heading_3 = document.createElement('th');
        heading_3.innerHTML = "name";
        let heading_4 = document.createElement('th');
        heading_4.innerHTML = "photo";
        let heading_5 = document.createElement('th');
        heading_5.innerHTML = "admin";
        let heading_6 = document.createElement('th');
        heading_6.innerHTML = "country";
        let heading_7 = document.createElement('th');
        heading_7.innerHTML = "gender";
        let heading_8 = document.createElement('th');
        heading_8.innerHTML = "birthday";

        row_1.appendChild(heading_1);
        row_1.appendChild(heading_2);
        row_1.appendChild(heading_3);
        row_1.appendChild(heading_4);
        row_1.appendChild(heading_5);
        row_1.appendChild(heading_6);
        row_1.appendChild(heading_7);
        row_1.appendChild(heading_8);
        thead.appendChild(row_1);
        var i=0;
        while(response.data[i]!=null){
          let row = document.createElement('tr');
          let row_data_1= document.createElement('td');
          row_data_1.innerHTML = response.data[i].id_users;
          let row_data_2= document.createElement('td');
          row_data_2.innerHTML = response.data[i].email;
          let row_data_3= document.createElement('td');
          row_data_3.innerHTML = response.data[i].name;
          let row_data_4= document.createElement('td');
          row_data_4.innerHTML = response.data[i].photo;
          let row_data_5= document.createElement('td');
          row_data_5.innerHTML = response.data[i].admin;
          let row_data_6= document.createElement('td');
          row_data_6.innerHTML = response.data[i].country;
          let row_data_7= document.createElement('td');
          row_data_7.innerHTML = response.data[i].gender;
          let row_data_8= document.createElement('td');
          row_data_8.innerHTML = response.data[i].birthday;
          let row_data_9= document.createElement('td');
          let row_data_10= document.createElement("button");
          row_data_10.name = response.data[i].id_users;
          row_data_10.type="button"
          row_data_10.onclick=function(){apagarUser(row_data_10.name);}
          row_data_10.classList.add("admin-conteudo-remove-button");
          row_data_9.appendChild(row_data_10);
          row.appendChild(row_data_1);
          row.appendChild(row_data_2);
          row.appendChild(row_data_3);
          row.appendChild(row_data_4);
          row.appendChild(row_data_5);
          row.appendChild(row_data_6);
          row.appendChild(row_data_7);
          row.appendChild(row_data_8);
          row.appendChild(row_data_9);
          tbody.appendChild(row);
          i++;
        }
    }
  });
}

function escreverPost(){
  removeTable();

  $.ajax({
    url:"/Admin/Post",
    type: "get",
    dataType: 'json',
    success: function(response){
        let table = document.createElement('table');
        table.id='table';
        let thead = document.createElement('thead');
        let tbody = document.createElement('tbody');
        table.appendChild(thead);
        table.appendChild(tbody);
        document.getElementById("admin-conteudo").appendChild(table);
        let row_1 = document.createElement('tr');
        let heading_1 = document.createElement('th');
        heading_1.innerHTML = "id_post";
        let heading_2 = document.createElement('th');
        heading_2.innerHTML = "id_users";
        let heading_3 = document.createElement('th');
        heading_3.innerHTML = "id_category";
        let heading_4 = document.createElement('th');
        heading_4.innerHTML = "total_up";
        let heading_5 = document.createElement('th');
        heading_5.innerHTML = "total_down";
        let heading_6 = document.createElement('th');
        heading_6.innerHTML = "date";
        let heading_7 = document.createElement('th');
        heading_7.innerHTML = "url";
        let heading_8 = document.createElement('th');
        heading_8.innerHTML = "media";
        let heading_9 = document.createElement('th');
        heading_9.innerHTML = "title";

        row_1.appendChild(heading_1);
        row_1.appendChild(heading_2);
        row_1.appendChild(heading_3);
        row_1.appendChild(heading_4);
        row_1.appendChild(heading_5);
        row_1.appendChild(heading_6);
        row_1.appendChild(heading_7);
        row_1.appendChild(heading_8);
        row_1.appendChild(heading_9);
        thead.appendChild(row_1);
        var i=0;
        while(response.data[i]!=null){
          let row = document.createElement('tr');
          let row_data_1= document.createElement('td');
          row_data_1.innerHTML = response.data[i].id_post;
          let row_data_2= document.createElement('td');
          row_data_2.innerHTML = response.data[i].id_users;
          let row_data_3= document.createElement('td');
          row_data_3.innerHTML = response.data[i].id_category;
          let row_data_4= document.createElement('td');
          row_data_4.innerHTML = response.data[i].total_up;
          let row_data_5= document.createElement('td');
          row_data_5.innerHTML = response.data[i].total_down;
          let row_data_6= document.createElement('td');
          row_data_6.innerHTML = response.data[i].date;
          let row_data_7= document.createElement('td');
          row_data_7.innerHTML = response.data[i].url;
          let row_data_8= document.createElement('td');
          row_data_8.innerHTML = response.data[i].media;
          let row_data_9= document.createElement('td');
          row_data_9.innerHTML = response.data[i].title;
          let row_data_10= document.createElement('td');
          let row_data_11= document.createElement("button");
          row_data_11.name = response.data[i].id_post;
          row_data_11.type="button"
          row_data_11.onclick=function(){apagarPost(row_data_11.name);}
          row_data_11.classList.add("admin-conteudo-remove-button");
          row_data_10.appendChild(row_data_11);
          row.appendChild(row_data_1);
          row.appendChild(row_data_2);
          row.appendChild(row_data_3);
          row.appendChild(row_data_4);
          row.appendChild(row_data_5);
          row.appendChild(row_data_6);
          row.appendChild(row_data_7);
          row.appendChild(row_data_8);
          row.appendChild(row_data_9);
          row.appendChild(row_data_10);
          tbody.appendChild(row);
          i++;
        }
    }
  });
}

function escreverComments(){
  removeTable();

  $.ajax({
    url:"/Admin/Comment",
    type: "get",
    dataType: 'json',
    success: function(response){
        let table = document.createElement('table');
        table.id='table';
        let thead = document.createElement('thead');
        let tbody = document.createElement('tbody');
        table.appendChild(thead);
        table.appendChild(tbody);
        document.getElementById("admin-conteudo").appendChild(table);
        let row_1 = document.createElement('tr');
        let heading_1 = document.createElement('th');
        heading_1.innerHTML = "id_comment";
        let heading_2 = document.createElement('th');
        heading_2.innerHTML = "id_users";
        let heading_3 = document.createElement('th');
        heading_3.innerHTML = "id_posts";
        let heading_4 = document.createElement('th');
        heading_4.innerHTML = "date";
        let heading_5 = document.createElement('th');
        heading_5.innerHTML = "comment";
        let heading_6 = document.createElement('th');
        heading_6.innerHTML = "total_up";
        let heading_7 = document.createElement('th');
        heading_7.innerHTML = "total_down";
        row_1.appendChild(heading_1);
        row_1.appendChild(heading_2);
        row_1.appendChild(heading_3);
        row_1.appendChild(heading_4);
        row_1.appendChild(heading_5);
        row_1.appendChild(heading_6);
        row_1.appendChild(heading_7);
        thead.appendChild(row_1);
        var i=0;
        while(response.data[i]!=null){
          let row = document.createElement('tr');
          let row_data_1= document.createElement('td');
          row_data_1.innerHTML = response.data[i].id_comment;
          let row_data_2= document.createElement('td');
          row_data_2.innerHTML = response.data[i].id_users;
          let row_data_3= document.createElement('td');
          row_data_3.innerHTML = response.data[i].id_post;
          let row_data_4= document.createElement('td');
          row_data_4.innerHTML = response.data[i].date;
          let row_data_5= document.createElement('td');
          row_data_5.innerHTML = response.data[i].comment;
          let row_data_6= document.createElement('td');
          row_data_6.innerHTML = response.data[i].total_up;
          let row_data_7= document.createElement('td');
          row_data_7.innerHTML = response.data[i].total_down;
          let row_data_8= document.createElement('td');
          let row_data_9= document.createElement("button");
          row_data_9.name = response.data[i].id_comment;
          row_data_9.type="button"
          row_data_9.onclick=function(){apagarComment(row_data_9.name);}
          row_data_9.classList.add("admin-conteudo-remove-button");
          row_data_8.appendChild(row_data_9);
          row.appendChild(row_data_1);
          row.appendChild(row_data_2);
          row.appendChild(row_data_3);
          row.appendChild(row_data_4);
          row.appendChild(row_data_5);
          row.appendChild(row_data_6);
          row.appendChild(row_data_7);
          row.appendChild(row_data_8);
          tbody.appendChild(row);
          i++;
        }
    }
  });
}

function escreverContact(){
  removeTable();
  $.ajax({
    url:"/Admin/Contact",
    type: "get",
    dataType: 'json',
    success: function(response){
        let table = document.createElement('table');
        table.id='table';
        let thead = document.createElement('thead');
        let tbody = document.createElement('tbody');
        table.appendChild(thead);
        table.appendChild(tbody);
        document.getElementById("admin-conteudo").appendChild(table);
        let row_1 = document.createElement('tr');
        let heading_1 = document.createElement('th');
        heading_1.innerHTML = "id_contact";
        let heading_2 = document.createElement('th');
        heading_2.innerHTML = "name";
        let heading_3 = document.createElement('th');
        heading_3.innerHTML = "email";
        let heading_4 = document.createElement('th');
        heading_4.innerHTML = "assunto";
        let heading_5 = document.createElement('th');
        heading_5.innerHTML = "pergunta";

        row_1.appendChild(heading_1);
        row_1.appendChild(heading_2);
        row_1.appendChild(heading_3);
        row_1.appendChild(heading_4);
        row_1.appendChild(heading_5);
        thead.appendChild(row_1);
        var i=0;
        while(response.data[i]!=null){
          let row = document.createElement('tr');
          let row_data_1= document.createElement('td');
          row_data_1.innerHTML = response.data[i].id_contact;
          let row_data_2= document.createElement('td');
          row_data_2.innerHTML = response.data[i].name;
          let row_data_3= document.createElement('td');
          row_data_3.innerHTML = response.data[i].email;
          let row_data_4= document.createElement('td');
          row_data_4.innerHTML = response.data[i].assunto;
          let row_data_5= document.createElement('td');
          row_data_5.innerHTML = response.data[i].pergunta;
          let row_data_6= document.createElement('td');
          let row_data_7= document.createElement("button");
          row_data_7.name = response.data[i].id_contact;
          row_data_7.type="button"
          row_data_7.onclick=function(){apagarContact(row_data_7.name);}
          row_data_7.classList.add("admin-conteudo-remove-button");
          row_data_6.appendChild(row_data_7);
          row.appendChild(row_data_1);
          row.appendChild(row_data_2);
          row.appendChild(row_data_3);
          row.appendChild(row_data_4);
          row.appendChild(row_data_5);
          row.appendChild(row_data_6);
          tbody.appendChild(row);
          i++;
        }
    }
  });
}

function escreverHelp(){
  removeTable();
  $.ajax({
    url:"/Admin/Help",
    type: "get",
    dataType: 'json',
    success: function(response){
        let table = document.createElement('table');
        table.id='table';
        let thead = document.createElement('thead');
        let tbody = document.createElement('tbody');
        table.appendChild(thead);
        table.appendChild(tbody);
        document.getElementById("admin-conteudo").appendChild(table);
        let row_1 = document.createElement('tr');
        let heading_1 = document.createElement('th');
        heading_1.innerHTML = "id_Help";
        let heading_2 = document.createElement('th');
        heading_2.innerHTML = "ideia";

        row_1.appendChild(heading_1);
        row_1.appendChild(heading_2);
        thead.appendChild(row_1);
        var i=0;
        while(response.data[i]!=null){
          let row = document.createElement('tr');
          let row_data_1= document.createElement('td');
          row_data_1.innerHTML = response.data[i].id_help;
          let row_data_2= document.createElement('td');
          row_data_2.innerHTML = response.data[i].ideia;
          let row_data_3= document.createElement('td');
          let row_data_4= document.createElement("button");
          row_data_4.name = response.data[i].id_help;
          row_data_4.type="button"
          row_data_4.onclick=function(){apagarHelp(row_data_4.name);}
          row_data_4.classList.add("admin-conteudo-remove-button");
          row_data_3.appendChild(row_data_4);
          row.appendChild(row_data_1);
          row.appendChild(row_data_2);
          row.appendChild(row_data_3);
          tbody.appendChild(row);
          i++;
        }
    }
  });
}

function apagarHelp(id){
  var _token = document.getElementsByName('csrf-token')[0].getAttribute('content');
  var dataEnv ={_token: _token,id: id}
  $.ajax({
    url:"/Admin/Help/Delete/" + id,
    type: "delete",
    data: dataEnv,
    dataType: 'json',
    success:function(response){
      escreverHelp();
    }
  });
}

function apagarUser(id){
  var _token = document.getElementsByName('csrf-token')[0].getAttribute('content');
  var dataEnv ={_token: _token,id: id}
  $.ajax({
    url:"/Admin/User/Delete/" + id,
    type: "delete",
    data: dataEnv,
    dataType: 'json',
    success:function(response){
      escreverUser();
    }
  });
}

function apagarPost(id){
  var _token = document.getElementsByName('csrf-token')[0].getAttribute('content');
  var dataEnv ={_token: _token,id: id}
  $.ajax({
    url:"/Admin/Post/Delete/" + id,
    type: "delete",
    data: dataEnv,
    dataType: 'json',
    success:function(response){
      escreverPost();
    }
  });
}

function apagarComment(id){
  var _token = document.getElementsByName('csrf-token')[0].getAttribute('content');
  var dataEnv ={_token: _token,id: id}
  $.ajax({
    url:"/Admin/Comment/Delete/" + id,
    type: "delete",
    data: dataEnv,
    dataType: 'json',
    success:function(response){
      escreverComments();
    }
  });
}

function apagarContact(id){
  var _token = document.getElementsByName('csrf-token')[0].getAttribute('content');
  var dataEnv ={_token: _token,id: id}
  $.ajax({
    url:"/Admin/Contact/Delete/" + id,
    type: "delete",
    data: dataEnv,
    dataType: 'json',
    success:function(response){
      escreverContact();
    }
  });
}
