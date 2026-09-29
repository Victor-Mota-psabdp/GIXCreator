SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_Customer_Profile_InsUpd]
	
	@ID_CP					int,
	@Cd_Cliente				varchar(10),
	@Modal					varchar(2),
	@Data					datetime,
	@Cd_Org					varchar(3),
	@Cd_Dst					varchar(3),
	@Cd_Agente				varchar(10),
	@Cd_SubAgente			varchar(10),
	@Cd_Vendedor			varchar(10),
	@Cd_Usuario				varchar(10),
	@Dt_Vencimento			datetime,
	@campo_obs				varchar(500),
	@Prazo					Varchar(200),
	@Dias					int,			
	@Cd_Tipo_Servico		char(1),
	@Contato				varchar(120),
	@Mercadoria				varchar(150),
	@Peso_TN				float,
	@Peso_CM3_M3			float,
	@Tipo_Carga				varchar(1),
	@Vlr_Venda				float,
	@ID_Status				Varchar(1),
	@ID_Registro			int,	
	@ID_CP_Ret			int OUTPUT	

AS

	Begin Transaction

	Declare @ID_CP_NEW		int
	
	IF @ID_CP is Null
		BEGIN
			Set @ID_CP_NEW = (select isnull(max(ID_CP)+1,1) from Customer_Profile)
			INSERT
				Customer_Profile(
					ID_CP, Cd_cliente, modal, data, cd_org, cd_dst, Cd_Agente, Cd_SubAgente, Cd_Vendedor, cd_usuario, Dt_Vencimento,campo_obs,prazo,dias,Cd_Tipo_Servico,Contato,Mercadoria,Peso_TN, Peso_CM3_M3, Tipo_Carga,Vlr_Venda,id_status_cp, ID_Registro
					)
			Values
				(
					@ID_CP_NEW, @cd_cliente, @modal, @data, @cd_org, @cd_dst, @Cd_Agente, @Cd_SubAgente, @Cd_Vendedor, @cd_usuario, @Dt_Vencimento,@campo_obs,@prazo,@Dias, @Cd_Tipo_Servico, @Contato,@Mercadoria, @Peso_TN, @Peso_CM3_M3, @Tipo_Carga, @Vlr_Venda,@ID_Status,@ID_Registro
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
				Cd_Agente = @Cd_Agente,
				Cd_SubAgente = @Cd_SubAgente,
				Cd_Vendedor = @Cd_Vendedor,
				cd_usuario = @cd_usuario,
				Dt_Vencimento = @Dt_Vencimento,
				campo_obs = @campo_obs,
				Prazo=@Prazo,
				Dias=@Dias,
				Contato=@Contato,
				Mercadoria=@Mercadoria,
				Cd_Tipo_Servico = @Cd_Tipo_Servico,
				Peso_TN = @Peso_TN,
				Peso_CM3_M3 = @Peso_CM3_M3,
				Tipo_Carga = @Tipo_Carga,
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
