<?php

namespace App\Http\Controllers\Static;

use App\Models\Contact;
use App\Models\Help;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class staticController extends Controller
{
    /**
     * Handle the incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function about(){
        return view( view: 'static.about');
    }

    public function faq(){
        return view( view: 'static.faq');
    }

    public function contact(){
        return view( view: 'static.contact');
    }
    public function contactSend(Request $request){
        $validacao = $request->validate(
            [
                'Name' => 'required',
                'Email' => 'required',
                'Assunto' => 'required',
                'Pergunta' => 'required',
            ]
        );

        $contact = new Contact();
        
        $contact->name = $request->Name;
        $contact->email = $request->Email;
        $contact->assunto = $request->Assunto;
        $contact->pergunta = $request->Pergunta;
        $contact->save();
        
        return redirect('/Contact')->with('msg', 'Entraremos em contacto assim que possivel');
    }
    public function help(){
        return view( view: 'static.help');
    }
    public function helpSend(Request $request){
        if($request->Text==null){
            $helpSend['success']=false;
            $helpSend['message']= "The text field needs to be filled";
            echo json_encode($helpSend);
            return;
        }

        $help = new Help();
        
        $help->ideia = $request->Text;
        $help->save();
        $helpSend['success']=true;
        $helpSend['message']= "Thanks for ur help";
        echo json_encode($helpSend);
        return;
        //return redirect('/Help')->with('msg', 'Obrigado pela sua ideia');
    }
}
