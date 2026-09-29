SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Alerta_Email_Doc_Automatico
CREATE procedure [dbo].[spATL_Alerta_Email_Doc_Automatico_Historico_InsUpd]
(
	@ID				int,
	@Num_Proc		varchar(16),
	@Cd_Pes_Grupo	varchar(10),
	@Modal			varchar(2),
	@cd_tp_carga	int,
	@cd_org			varchar(10),
	@cd_dst			varchar(10),
	@cd_tp_pedido	varchar(1),
	@Cd_Pes			varchar(10),
	@Cd_Transportadora varchar(10),
	@Cd_Terminal	varchar(10),
	@Id_Alerta		bigint
)
AS

BEGIN
	BEGIN TRY		
		BEGIN		    
			insert into Alerta_Email_Doc_Automatico_Historico
				(
					Id,Num_Proc,Dt_Envio,Cd_Pes_Grupo,Modal,cd_tp_carga,
					Cd_Org,Cd_Dst,cd_tp_pedido,Cd_Pes,Cd_Transportadora,Cd_Terminal
					,ID_Alerta
				)
				values
				(			
					@ID,@Num_Proc,GETDATE(),@Cd_Pes_Grupo,@Modal,@cd_tp_carga,
					@cd_org,@cd_dst,@cd_tp_pedido,@Cd_Pes,@Cd_Transportadora,@Cd_Terminal
					,@ID_Alerta
				)				  
			END	

			Select @Id_Alerta as Retorno;	

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	
END


/*
ALTER procedure [dbo].[spATL_Alerta_Email_Doc_Automatico_Historico_InsUpd]
(
	@ID				int,
	@Num_Proc		[varchar](16),
	@Cd_Pes_Grupo	[varchar](10),
	@Modal			[varchar](2),
	@cd_tp_carga	int,
	@cd_org			[varchar](10),
	@cd_dst			[varchar](10),
	@cd_tp_pedido	[varchar](1),
	@Cd_Pes			[varchar](10),
	@Cd_Transportadora [varchar](10),
	@Cd_Terminal	[varchar](10),
	@Id_Alerta		[bigint]
)	
	
AS

BEGIN
	insert into Alerta_Email_Doc_Automatico_Historico
	(
		Id,Num_Proc,Dt_Envio,Cd_Pes_Grupo,Modal,cd_tp_carga,
		Cd_Org,Cd_Dst,cd_tp_pedido,Cd_Pes,Cd_Transportadora,Cd_Terminal
		,ID_Alerta
	)
	values
	(			
		@ID,@Num_Proc,GETDATE(),@Cd_Pes_Grupo,@Modal,@cd_tp_carga,
		@cd_org,@cd_dst,@cd_tp_pedido,@Cd_Pes,@Cd_Transportadora,@Cd_Terminal
		,@ID_Alerta
	)
END

*/
GO
