SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spNF_GIX2ATL_InsUpd] 

		@ID_NF							int,
		@CNPJ							Varchar(15),
		@Nota_Fiscal					Varchar(20),
		@Emissao						datetime,	
		@CFOP							Varchar(10),
		@Invoice						Varchar(30),
		@Cd_Exportador					Varchar(20),
		@Vlr_NF							float,
		@Cliente						Varchar(50),
		@Complementar					char(1),
		@ID_NF_FK						int,
		@DI								Varchar(25),
		@Data_DI						datetime,
		@Paridade						float,
		@Num_Proc						Varchar(16),
		@ID_NF_N						int OUTPUT,
		@Data_Envio						datetime, 
		@Mensagem_erro					varchar(200),
		@cnpj_destinatario				varchar(15), 
		@serie							varchar(10),
		@intnlog						int,
		@intnaleatorio					int,
		@intdigitocontrole				int, 
		@cd_ibge_municipio_gerador		int,
		@cd_ibge_municipio_emitente		int,
		@cd_ibge_municipio_destinatario int,
		@cd_pais_bacen					int,
		@vlr_tot_base_icms				decimal(15,2),
		@vlr_tot_icms					decimal(15,2),
		@vlr_tot_base_icms_st			decimal(15,2),
		@vlr_tot_icms_st				decimal(15,2),
		@vlr_tot_prod_serv				decimal(15,2),
		@vlr_tot_frete					decimal(15,2),
		@vlr_tot_seguro					decimal(15,2),
		@vlr_tot_desconto				decimal(15,2),
		@vlr_tot_ipi					decimal(15,2),
		@vlr_tot_pis					decimal(15,2),
		@vlr_tot_cofins					decimal(15,2),
		@vlr_tot_outras_desp			decimal(15,2),
		@cd_transp						varchar(10),
		@info_complementar				varchar(200)
AS
Begin Transaction

	Declare	@Cd_Cliente	Varchar(10)

	Set @Cd_Cliente = (Select top 1 Cd_Pes from Pessoa where apelido = @Cliente)

	if @ID_NF is null 
		Begin
			IF not exists (select ID_NF from Nota_Cliente where num_proc=@num_proc and nota_fiscal=@nota_fiscal) 
				BEGIN				
					Set @ID_NF=(Select iSNULL(max(ID_NF),0)+1 from Nota_Cliente where Cd_cliente = @Cd_Cliente)  

					Insert Into Nota_Cliente
						(ID_NF,CNPJ,Nota_Fiscal,Emissao,CFOP,Invoice,Cd_Exportador,Vlr_NF,CD_Cliente,
						Complementar,ID_NF_FK,DI,Data_DI,Paridade,Num_Proc,Data_Envio,Mensagem_erro,cnpj_destinatario,
					    serie,intnlog,intnaleatorio,intdigitocontrole,cd_ibge_municipio_gerador,
						cd_ibge_municipio_emitente,cd_ibge_municipio_destinatario,cd_pais_bacen,
						vlr_tot_base_icms,vlr_tot_icms,vlr_tot_base_icms_st,vlr_tot_icms_st,
						vlr_tot_prod_serv,vlr_tot_frete,vlr_tot_desconto,vlr_tot_seguro,
						vlr_tot_ipi,vlr_tot_pis,vlr_tot_cofins,vlr_tot_outras_desp,cd_transp,info_complementar
						)
					Values
						(@ID_NF,@CNPJ,@Nota_Fiscal,@Emissao,@CFOP,@Invoice,@Cd_Exportador,@Vlr_NF,@CD_Cliente,
						@Complementar,@ID_NF_FK,@DI,@Data_DI,@Paridade,@Num_Proc,@Data_Envio,@Mensagem_erro,
					    @cnpj_destinatario,@serie,@intnlog,@intnaleatorio,@intdigitocontrole,@cd_ibge_municipio_gerador,
						@cd_ibge_municipio_emitente,@cd_ibge_municipio_destinatario,@cd_pais_bacen,@vlr_tot_base_icms,
						@vlr_tot_icms,@vlr_tot_base_icms_st,@vlr_tot_icms_st,@vlr_tot_prod_serv,@vlr_tot_frete,
						@vlr_tot_seguro,@vlr_tot_desconto,@vlr_tot_ipi,	@vlr_tot_pis,@vlr_tot_cofins,@vlr_tot_outras_desp,
						@cd_transp,@info_complementar
						)
					
					Set @ID_NF_N=@ID_NF	
				END	
			ELSE
				begin
					SET @ID_NF_N = (select top 1 ID_NF from Nota_Cliente where num_proc=@num_proc and nota_fiscal=@nota_fiscal) 
				end
		End		
	Else
		Begin					
				Update
					Nota_Cliente
				Set			
					--CNPJ							= @CNPJ,
					Nota_Fiscal 					= @Nota_Fiscal,
					Emissao							= @Emissao,
					CFOP							= @CFOP,
					Invoice							= @Invoice,
					Cd_Exportador					= @Cd_Exportador,
					Vlr_NF							= @Vlr_NF,
					CD_Cliente						= @Cd_Cliente,
					Complementar					= @Complementar,
					ID_NF_FK						= @ID_NF_FK,
					DI								= @DI,
					Data_DI							= @Data_DI,
					Paridade						= @Paridade,
					Data_Envio						= @Data_Envio,
					Mensagem_erro					= @Mensagem_erro,
					cnpj_destinatario				= @cnpj_destinatario,
					serie							= @serie,
					intnlog							= @intnlog,
					intnaleatorio					= @intnaleatorio,
					intdigitocontrole				= @intdigitocontrole,
					cd_ibge_municipio_gerador		= @cd_ibge_municipio_gerador,
					cd_ibge_municipio_emitente		= @cd_ibge_municipio_emitente,
					cd_ibge_municipio_destinatario	= @cd_ibge_municipio_destinatario,
					cd_pais_bacen					= @cd_pais_bacen,
					vlr_tot_base_icms				= @vlr_tot_base_icms,
					vlr_tot_icms					= @vlr_tot_icms,
					vlr_tot_base_icms_st			= @vlr_tot_base_icms_st,
					vlr_tot_icms_st					= @vlr_tot_icms_st,
					vlr_tot_prod_serv				= @vlr_tot_prod_serv,
					vlr_tot_frete					= @vlr_tot_frete,
					vlr_tot_seguro					= @vlr_tot_seguro,
					vlr_tot_desconto				= @vlr_tot_desconto,
					vlr_tot_ipi						= @vlr_tot_ipi,
					vlr_tot_pis						= @vlr_tot_pis,
					vlr_tot_cofins					= @vlr_tot_cofins,
					vlr_tot_outras_desp				= @vlr_tot_outras_desp,
					cd_transp						= @cd_transp,
					info_complementar				= @info_complementar,
					Dt_Envio_RM						= NULL
				where
					Num_Proc = @Num_Proc and ID_NF= @ID_NF
					
				Set @ID_NF_N=@ID_NF
			end					

		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

Commit Transaction


GO
