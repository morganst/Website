class ContactsController < ApplicationController
  
  #get request to /contact-us
  #show new contact form
  def new
    @contact = Contact.new
  end
  
  #POST request /contacts
  def create
    #mass assignment of form fields into contact object
    @contact = Contact.new(contact_params)
    #save the object to database
    if @contact.save
      #store form fields into variables
      name = params[:contact][:name]
      email = params[:contact][:email]
      body = params[:contact][:comments]
      ContactMailer.contact_email(name, email, body).deliver
      flash[:success] = "Message sent."
      #redirect to new contact
      redirect_to new_contact_path
    else 
      #doesnt save: eroor msg(s)
      #redirect to new contact
      flash[:danger] = @contact.errors.full_messages.join(", ")
      redirect_to new_contact_path
    end
  end
  
  private 
  #strong parameters
  #security
  def contact_params 
    params.require(:contact).permit(:name, :email, :comments)
  end
end
