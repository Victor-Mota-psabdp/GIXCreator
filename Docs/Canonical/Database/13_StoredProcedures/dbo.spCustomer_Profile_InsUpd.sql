SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      procedure [dbo].[spCustomer_Profile_InsUpd]
	
	@ID_CP			int,
	@cliente		varchar(50),
	@modal			varchar(2),
	@data			datetime,
	@org			varchar(30),
	@dst			varchar(30),
	@agente			varchar(50),
	@subagente		varchar(50),
	@vendedor		varchar(50),
	@usuario		varchar(50),
	@dt_vencimento	datetime,
	@campo_obs		varchar(500),
	@Prazo			Varchar(200),
	@Dias			int,
	@Tipo_Servico	varchar(50),
	@Contato		varchar(120),
	@Mercadoria		varchar(150),
	@Peso_TN		float,
	@Peso_CM3_M3	float,
	@Tipo_Carga		varchar(50),
	@Vlr_Venda		float,
	@ID_CP_Ret		int OUTPUT,
	@ID_Status		Varchar(1),
	@ID_Registro	int

AS

	Begin Transaction
	
	Declare @cd_cliente		varchar(10)
	Declare @cd_org			varchar(3)
	Declare @cd_dst			varchar(3)
	Declare @cd_agente		varchar(10)
	Declare @cd_subagente	varchar(10)
	Declare @cd_vendedor	varchar(10)	
	Declare @Cd_Tipo_Servico char(1)
	Declare @Cd_Usuario		varchar(10)
	Declare @ID_CP_NEW		int
	Declare @Cd_Tipo_Carga	varchar(1)
	

	set @cd_cliente = (select cd_pes from pessoa with(nolock) where apelido = @cliente)

	if @org <> 'ALL'
		Begin
			set @cd_org = (select top 1 cd_local from localidade with(nolock) where nome_local=@org)
		end
	else
		Begin
			set @cd_org = 'ALL'
		end

	if @DST <> 'ALL'
		Begin
			set @cd_dst = (select top 1 cd_local from localidade with(nolock) where nome_local=@dst)
		end
	else
		Begin
			set @cd_dst = 'ALL'
		End
	
	set @cd_agente = (select cd_pes from pessoa with(nolock) where apelido = @agente)
	set @cd_subagente = (select cd_pes from pessoa with(nolock) where apelido = @subagente)
	set @Cd_Tipo_Servico = (select cd_tipo_servico from Tipo_Servico_CP with(nolock) where Descr_Servico = @Tipo_Servico )
	set @Cd_Usuario = (select cd_usuario from Usuario with(nolock) where nome_usuario = @Usuario)
	set @Cd_Vendedor = (select cd_usuario from Usuario with(nolock) where nome_usuario = @Vendedor)
	set @Cd_Tipo_Carga = (Select Cd_Tp_Carga from Tipo_Carga with(nolock) where Nome_Tp_Carga = @Tipo_Carga)

	IF @ID_CP is Null
		BEGIN
			Set @ID_CP_NEW = (select isnull(max(ID_CP)+1,1) from Customer_Profile)
			INSERT
				Customer_Profile(
					ID_CP, Cd_cliente, modal, data, cd_org, cd_dst, cd_agente, cd_subagente, cd_vendedor, cd_usuario, dt_vencimento,campo_obs,prazo,dias,Cd_Tipo_Servico,Contato,Mercadoria,Peso_TN, Peso_CM3_M3, Tipo_Carga,Vlr_Venda,id_status_cp, ID_Registro
					)
			Values
				(
					@ID_CP_NEW, @cd_cliente, @modal, @data, @cd_org, @cd_dst, @cd_agente, @cd_subagente, @cd_vendedor, @cd_usuario, @dt_vencimento,@campo_obs,@prazo,@Dias, @Cd_Tipo_Servico, @Contato,@Mercadoria, @Peso_TN, @Peso_CM3_M3, @Cd_Tipo_Carga, @Vlr_Venda,@ID_Status,@ID_Registro
				)
			set @ID_CP_Ret = @ID_CP_NEW
		END
		
	ELSE
		BEGIN
			UPDATE
				Customer_profile
			SET
				modal = @modal,
				data = @data,
				Cd_Org = @Cd_Org,
				Cd_Dst = @Cd_Dst,
				cd_agente = @cd_agente,
				cd_subagente = @cd_subagente,
				cd_vendedor = @cd_vendedor,
				cd_usuario = @cd_usuario,
				dt_vencimento = @dt_vencimento,
				campo_obs = @campo_obs,
				Prazo=@Prazo,
				Dias=@Dias,
				Contato=@Contato,
				Mercadoria=@Mercadoria,
				Cd_Tipo_Servico = @Cd_Tipo_Servico,
				Peso_TN = @Peso_TN,
				Peso_CM3_M3 = @Peso_CM3_M3,
				Tipo_Carga = @Cd_Tipo_Carga,
				Vlr_Venda = @Vlr_Venda,
				Id_status_cp=@ID_Status,
				ID_Registro=@ID_Registro
			WHERE
				ID_CP = @ID_CP
			
		END

	IF @@Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
Commit Transaction










GO
