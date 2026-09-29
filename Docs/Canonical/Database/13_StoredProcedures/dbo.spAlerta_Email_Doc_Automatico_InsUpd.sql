SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Alerta_Email_Doc_Automatico
CREATE procedure [dbo].[spAlerta_Email_Doc_Automatico_InsUpd]
(
	--@ID								int,
	@ID_Alerta						bigint,
	@Nome_Task						varchar(30),
	@Id_Task						int,	
	@Cd_Pes_Grupo					varchar(10),
	@Modal							varchar(2),
	@Dias							float,
	@ResponderPara					varchar(100),
	@Emails							varchar(2500),	
	@Doc_Anexos						varchar(500),	
	@Mensagem						varchar(2000),		
	@Ativo							bit,	
	@Nome_Tp_Ocor					varchar(50),
	@JuntaPDF						char(1),	
	@Dt_Ins							Datetime,
	@Cd_Usuario						varchar(6),	
	@CopyBDP						varchar(2500),
	@Email_do_CompanyRegister		bit,	
	@Cd_Tp_Carga					int,
	@Doc_Anexos_Nao					varchar(500),
	@Cd_Org							varchar(3),
	@Cd_Dst							varchar(3),
	@Assunto						varchar(200),
	@StandardForms					varchar(500),
	@Cd_Tp_Pedido					char(1),
	@Cd_Pes							varchar(10),
	@Email_do_Agente_Consolidado	bit,	
	@Cd_Transportadora				varchar(10),
	@CopyEmail						bit,
	@Cd_Terminal					varchar(10),
	@Zip							bit,

	@Cd_Pes_Out						varchar(10),
	@Id_NCM							int ,
	@Cd_Pes_Agent					varchar(10),
	@Id_Necessidade_LI				int ,
	@Cd_Armador						varchar(25) ,
	--@Cd_Cia_Aer						varchar(3) ,
	--@Cd_Pes_Armador					varchar(10),
	@Cd_Tp_Cont						varchar(3),
	@Cd_Prod						int,
	--Leandro
	@ID_PD							int,
	@Cd_Pes_Operador				varchar(10),
	@Id_Hazardous					int,
	@Cd_Usuario_Cliente				varchar(20),
	@BlindCopyBDP					varchar(2500)
)

AS

BEGIN

	BEGIN TRY

		BEGIN TRANSACTION;
			Declare @ID_New as bigint;

			if	@Cd_Pes_Grupo = '10017'
				begin
					set @Cd_Pes_Grupo = 'ALL'
				end
		    
			IF exists(select [ID_Alerta] from Alerta_Email_Doc_Automatico where [ID_Alerta] = @ID_Alerta)
				BEGIN
					UPDATE
					Alerta_Email_Doc_Automatico
				SET
					[Nome_Task] = @Nome_Task,
					[Id_Task] = @Id_Task ,
					[Cd_Pes_Grupo] = @Cd_Pes_Grupo,
					[Modal] = @Modal,
					[Dias] = @Dias,
					[ResponderPara] = @ResponderPara,
					[Emails] = @Emails,
					[Doc_Anexos] = @Doc_Anexos,	
					[Mensagem] = @Mensagem,
					[Ativo] = @Ativo,
					[Nome_Tp_Ocor] = @Nome_Tp_Ocor,
					[JuntaPDF] = @JuntaPDF,
					[Cd_Usuario] = @Cd_Usuario,
					[CopyBDP] = @CopyBDP,
					[Email_do_CompanyRegister] = @Email_do_CompanyRegister,
					[cd_tp_carga] = @cd_tp_carga,
					[Doc_Anexos_Nao] = @Doc_Anexos_Nao,
					[Cd_Org] = @cd_org,
					[Cd_Dst] =@cd_dst,
					[Assunto] = @Assunto,
					[StandardForms] = @StandardForms,	
					[cd_tp_pedido] = @cd_tp_pedido,
					[cd_pes]= @Cd_Pes,
					[Email_do_Agente_Consolidado] = @Email_do_Agente_Consolidado,
					[Cd_transportadora] = @Cd_Transportadora,
					[CopyEmail] =@CopyEmail,
					[Cd_Terminal] = @Cd_Terminal,
					[Zip] = @Zip,
					[Cd_Pes_Out]=@Cd_Pes_Out,	
					[Id_NCM]=@Id_NCM,	
					[Cd_Pes_Agent]=@Cd_Pes_Agent,	
					[Id_Necessidade_LI]=@Id_Necessidade_LI,	
					[Cd_Armador]=@Cd_Armador,	
					[Cd_Tp_Cont]=@Cd_Tp_Cont,	
					[Cd_Prod] =@Cd_Prod,
					--Leandro
					[ID_PD] = @ID_PD,
					[Cd_Pes_Operador]=@Cd_Pes_Operador,
					[Id_Hazardous]=@Id_Hazardous,
					[Cd_Usuario_Cliente]=@Cd_Usuario_Cliente,
					[BlindCopyBDP] = @BlindCopyBDP
				WHERE
					[ID_Alerta] = @ID_Alerta

					set @ID_New = @ID_Alerta;
				END
			ELSE
				BEGIN
					insert into Alerta_Email_Doc_Automatico
					(				
						[Nome_Task] ,[Id_Task],[Cd_Pes_Grupo],[Modal],[Dias],[ResponderPara],
						[Emails],[Doc_Anexos],[Mensagem],[Ativo],[Nome_Tp_Ocor],[JuntaPDF],	
						[Dt_Ins],[Cd_Usuario],[CopyBDP],[Email_do_CompanyRegister],[cd_tp_carga],
						Doc_Anexos_Nao,Cd_Org,Cd_Dst,Assunto,StandardForms,cd_tp_pedido,
						cd_pes,Email_do_Agente_Consolidado,Cd_transportadora,CopyEmail,Cd_Terminal,Zip,
						Cd_Pes_Out,Id_NCM,Cd_Pes_Agent,Id_Necessidade_LI,Cd_Armador,Cd_Tp_Cont,Cd_Prod,
						ID_PD,Cd_Pes_Operador,Id_Hazardous,Cd_Usuario_Cliente,BlindCopyBDP
					)
					values
					(
						@Nome_Task,@Id_Task,@Cd_Pes_Grupo,@Modal,@Dias,@ResponderPara,
						@Emails,@Doc_Anexos,@Mensagem,@Ativo,@Nome_Tp_Ocor,@JuntaPDF,
						GETDATE(),@Cd_Usuario,@CopyBDP,@Email_do_CompanyRegister,@cd_tp_carga,
						@Doc_Anexos_Nao,@cd_org,@cd_dst,@Assunto,@StandardForms,@cd_tp_pedido,@Cd_Pes,
						@Email_do_Agente_Consolidado,@Cd_Transportadora,@CopyEmail,@Cd_Terminal,@Zip,
						@Cd_Pes_Out,@Id_NCM,@Cd_Pes_Agent,@Id_Necessidade_LI,@Cd_Armador,@Cd_Tp_Cont,@Cd_Prod,
						@ID_PD,@Cd_Pes_Operador,@Id_Hazardous,@Cd_Usuario_Cliente,@BlindCopyBDP
					)

					set @ID_New = @@IDENTITY;
				END
			
	
			Select @ID_New as Retorno;		
		
		COMMIT TRANSACTION;
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END
GO
