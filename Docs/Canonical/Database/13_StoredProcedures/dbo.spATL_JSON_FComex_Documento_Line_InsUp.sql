SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_JSON_FComex_Documento_Line_InsUp]
(
	@Id_Processo		[bigint],
	@Id_Item			[bigint],
	@filename			[varchar](200),
	@file				[varchar](max),
	@Tipo_Documento		[varchar](200),
	@Palavras_Chave		[varchar](200),
	@Data_Documento		[varchar](200),
    @Transmitir			[varchar](200),
    @Painel				[varchar](200),
    @Identificacao		[varchar](200),
   	@Dt_Ins_Atl			Datetime,
	@Message			[varchar](2000),
	@ID					[bigint],			
	@FileFullPath		[varchar](5000),
	@PC_codigo			[varchar](500),
	@PC_descricao		[varchar](500),
	@PC_valor			[varchar](500),
	@TD_codigo			[varchar](500),
	@TD_descricao		[varchar](500)
)

AS
Begin Transaction
--Exceção(try/CATCH)
--Transação
--sp_help ATL_INT.dbo.JSON_FComex_Documento_Line

	BEGIN 
		IF exists(select Id_Processo from ATL_INT.dbo.JSON_FComex_Documento_Line 
		          where Id_Processo = @Id_Processo and Id_Item =@Id_Item)
			Begin
				Update
					ATL_INT.dbo.JSON_FComex_Documento_Line
				Set					
					[filename]			=	@filename,
					[file]				=	@file,
					[Tipo_Documento]	=	@Tipo_Documento,
					[Palavras_Chave]	=	@Palavras_Chave ,
					[Data_Documento]	=	@Data_Documento ,
					[Transmitir]		=	@Transmitir, 
                    [Painel]			=	@Painel,
                    [Identificacao]		=   @Identificacao,
					[Dt_Ins_Atl]		=	@Dt_Ins_Atl,
					[Message]			=	@Message ,
					[FileFullPath]		=	@FileFullPath, 
                    [PC_codigo]			=	@PC_codigo,
                    [PC_descricao]		=   @PC_descricao,
					[PC_valor]			=	@PC_valor,
					[TD_codigo]			=	@TD_codigo,
                    [TD_descricao]		=   @TD_descricao
				Where
					Id_Processo = @Id_Processo 
					and Id_Item=@Id_Item and [Dt_Ins_Atl] is null
			End
		Else
			BEGIN
				Insert ATL_INT.dbo.JSON_FComex_Documento_Line
				(
					[Id_Processo],[Id_Item],[filename],[file],[Tipo_Documento],[Palavras_Chave],[Data_Documento],[Transmitir],[Painel],[Identificacao],[Dt_Ins_Atl],
					[Message],FileFullPath,PC_codigo,PC_descricao,PC_valor,TD_codigo,TD_descricao
				)
				Values
				(
					@Id_Processo,@Id_Item,@filename,@file,@Tipo_Documento,@Palavras_Chave ,@Data_Documento ,@Transmitir,@Painel,@Identificacao,null,
					@Message,@FileFullPath,@PC_codigo,@PC_descricao,@PC_valor,@TD_codigo,@TD_descricao
				)
			END	
    END 
if @@error <> 0
		Begin

			RollBack Transaction
			return 0
		End
Commit Transaction
GO
