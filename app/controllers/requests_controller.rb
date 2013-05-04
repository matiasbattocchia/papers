# TODO
#
# * Lockeo de pedidos — Según sesión. 
#
# * Continuar respondiendo — Cargar nueva respuesta
#   en lugar de cargar la página principal.
#
# * Autocompletar el correo — Cargar nuevo
#   pedido/respuesta manteniendo el correo ingresado.
#
# * Ordenar también por reputación del usuario.
#
# * Borrar un pedido autorespondiéndolo en blanco.
#
# * Cambiar/borrar datos de usuario.


# REQUEST STATUS TABLE
#
# -3  3rd display — Latent
# -2  2nd display
# -1  1st display 
#  0  Active
#
#
# ACTIVO
#
#   Término de vida (3 días):
#     Cambio al estado LATENTE => Envío proposición de renovación.
#
#   Término de vistas (3 muestras):
#     Cambio al estado LATENTE => Envío proposición de renovación,
#     junto con enlace para revisión.
#
#   Contestación:
#     Cambio al estado LATENTE => Envío de archivo junto con
#     proposición de renovación.
#
#
# LATENTE
#
#   Término de vida (1 día):
#     => Eliminación.
#
#   Renovación:
#     Cambio al estado ACTIVO.


class RequestsController < ApplicationController
  # GET /requests
  def index
    # Si un pedido ya tiene un puntaje de -3, no se muestra.
    @requests = Request.where(:status => (-2..0), :lock => 'false').order('updated_at ASC')

    respond_to do |format|
      format.html # index.html.erb
#      format.json { render json: @requests }
    end
  end
  
  # GET /requests/1
  def display
    @request = Request.find(params[:id])

    respond_to do |format|
      unless false #@request.locked?
        #@request.lock!
        @request.degrade!
        @request.save
        format.html # index.html.erb
#        format.json { render json: @requests }
      else
#        format.html { redirect_to next_request, notice: 'Alguien esta respondiendo el pedido seleccionado; fuiste redireccionado al siguiente de la cola.' }
      end
    end
  end
  
  # POST /requests
  def post
    @request = Request.new(params[:request])
    @request.url = params[:url]
    @request.message = params[:message]

    @request.user = User.summon params[:requester_email]

    respond_to do |format|
      if @request.save
        format.html { redirect_to :root, notice: "Pedido ingresado." }
#        format.json { render json: @request, status: :created, location: @request }
      else
        format.html { render action: 'index' }
#        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /requests/1/upload
  def upload
    @request = Request.find(params[:id])
    @request.attachment = params[:attachment]

    # User.summon params[:responder_mail]
    
    respond_to do |format|
      if @request.attachment? # esto funciona?

        # El attachment queda en el caché. No se guarda en el disco.
        ResponseMailer.respond(@request).deliver
        @request.attachment = nil
        @request.deactivate!
        @request.save
        format.html { redirect_to :root, notice: 'Respuesta enviada.' }
#        format.json { render json: @request, status: :created, location: @request }
      else
        format.html { render action: 'display' }
#        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end


  # PUT /requests/1/repost
  def repost
    @request = Request.find(params[:id])
    @request.activate! if @request.latent?
  
    respond_to do |format|
      format.html { redirect_to 'index', notice: "Pedido reactivado." }
    end
  end

############################################################
  # DELETE /requests/1
  def destroy
    @request = Request.find(params[:id])
    @request.destroy

    respond_to do |format|
      format.html { redirect_to requests_url }
      format.json { head :no_content }
    end
  end
end
