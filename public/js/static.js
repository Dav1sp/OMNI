//FAQ

const faqs= document.querySelectorAll(".faq");

faqs.forEach(faq=>{
    faq.addEventListener("click", () => {
        faq.classList.toggle("active");
    });
});

//help
$(function(){
    $('form[name="help"]').submit(function(event){
        event.preventDefault();

        $.ajax({
            url:"/Help/Send",
            type: "post",
            data: $(this).serialize(),
            dataType: 'json',
            success: function(response){

                if(response.success===true){
                    window.location.href = "/Help"
                    $('.msg-positive').html(response.message);
                    document.getElementById("msg-positive").style.display = "block";
                    setTimeout(function(){
                        document.getElementById("msg-positive").style.display = "none";
                    },3000);
                }
                else{
                    $('.msg-negative').html(response.message).addClass("msg-negative-error");
                    document.getElementById("msg-negative").style.display = "block";
                    setTimeout(function(){
                        document.getElementById("msg-negative").style.display = "none";
                    },3000);
                }
            }
        });
    });
});
