SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_JSON_FComex_JobReferences_Line_InsUp]

	@Id_Processo [bigint],
	@Processo [varchar](200),
	@Num_Proc [varchar](200),
	@Order [varchar](200),
	@Master [varchar](200) NULL,
	@House [varchar](200) NULL,
	@Channel [varchar](200) NULL,
	@Terminal [varchar](200) NULL,
	@Incoterm [varchar](200) NULL,
	@Cd_Moeda_Frete  [varchar](200) NULL,
	@Valor_Frete [varchar](200) NULL,
	@TipoDoc [varchar](200) NULL,
	@NumeroDoc [varchar](200) NULL,
	@DataDi [varchar](200) NULL,
	@DataCi [varchar](200) NULL,
	@Transmissao [varchar](200) NULL,
	@DataDesembaraco [varchar](200) NULL,
	@PresencaDeCarga [varchar](200) NULL,
	@Paridade [varchar](200) NULL,
	@ParidadeDolar  [varchar](200) NULL,
	@SystemCode [numeric](2) NULL,
	@Message [varchar](max) NULL,
	@Id_Empresa [bigint],
	@Dt_Ins_Atl  [varchar](200) NULL
	   	  
AS
BEGIN TRANSACTION;
--Exceção(try/CATCH)
--Transação
--sp_help JSON_FComex_JobReferences

-- 03-10-2025 - BDP Support Ticket#100-543601 Lucina pediu para não atualizar o MASTER do job 
set @Master = null

		IF exists(select  Id_Processo from ATL_INT.dbo.JSON_FComex_JobReferences_Line 
		          where Id_Processo = @Id_Processo)
			Begin
				Update
					ATL_INT.dbo.JSON_FComex_JobReferences_Line
				Set					
						[Processo] = @Processo,
						[Num_Proc] = @Num_Proc,
						[Order] = @Order,
						[Master] =@Master,
						[House] =@House,
						[Channel] = @Channel,
						[Terminal] = @Terminal,
						[Incoterm]=@Incoterm,
						[Cd_Moeda_Frete]=@Cd_Moeda_Frete,
						[Valor_Frete]=@Valor_Frete,
                        [TipoDoc] = @TipoDoc,
						[NumeroDoc] = @NumeroDoc, 
						[DataDi] =@DataDi, 
						[DataCi] =@DataCi,
						[Transmissao]=@Transmissao,
						[DataDesembaraco] =@DataDesembaraco,
						[PresencaDeCarga] =@PresencaDeCarga,
						[Paridade] = @Paridade,
						[SystemCode] =@SystemCode,
						[Message]=@Message,
						[Id_Empresa] =@Id_Empresa,
						[Dt_Ins_Atl] = @Dt_Ins_Atl
				Where
					Id_Processo = @Id_Processo 	
			End
		Else
			BEGIN
				Insert ATL_INT.dbo.JSON_FComex_JobReferences_Line
				(
						[Id_Processo],
						[Processo],
						[Num_Proc],
						[Order],
						[Master],
						[House],
						[Channel],
						[Terminal],
						[Incoterm],
						[Cd_Moeda_Frete],
						[Valor_Frete],
                        [TipoDoc],
						[NumeroDoc],
						[DataDi], 
						[DataCi],
						[Transmissao],
						[DataDesembaraco],
						[PresencaDeCarga],
						[Paridade],
						[ParidadeDolar],
						[SystemCode],
						[Message],
						[Id_Empresa],
						[Dt_ins],
						[Dt_Ins_Atl]
				)
				Values
				(
					    @Id_Processo,
						@Processo,
						@Num_Proc,
						@Order,
						@Master,
						@House,
						@Channel,
						@Terminal,
						@Incoterm,
						@Cd_Moeda_Frete,
						@Valor_Frete,
                        @TipoDoc,
						@NumeroDoc,
						@DataDi, 
						@DataCi,
						@Transmissao,
						@DataDesembaraco,
						@PresencaDeCarga,
						@Paridade,
						@ParidadeDolar,
						@SystemCode,
						@Message,
						@Id_Empresa,
						GETDATE(),
						null
				)
			END	
if @@error <> 0
		Begin

			RollBack Transaction
			return 0
		End

Commit Transaction

GO
