SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[fDW_PYMNT_TERM_CD]
(
	@Num_Proc Varchar(16),
	@Type varchar(4)
)

returns varchar(250)

AS 

BEGIN
	
	Declare @Valor varchar(250)
	SET @Valor = ''

		if	@Type = 'Code'
		BEGIN
			set @valor=(				
					Select top 1 Isnull(TP.Cd_Termo,'281') cd_Termo from Pedido_Ship PS With(Nolock)
					Join Pedido	P With(Nolock)	on PS.Cd_Pedido = P.Cd_Pedido
					Left Join Campo_Processo CP87 on CP87.Num_proc = PS.Num_proc and CP87.Id_Campo = 87
					left Join  TErmo_PAgamento TP With(Nolock) on cast(TP.cd_termo as varchar(30))=P.payment
					where PS.Num_Proc = @Num_Proc
				)
		END	
		else
		BEGIN
			set @valor=(				
					Select top 1 Isnull(Descricao_Termo,'60 Days of Invoice Date') Termo from Pedido_Ship PS With(Nolock)
					Join Pedido	P With(Nolock)	on PS.Cd_Pedido = P.Cd_Pedido
					Left Join Campo_Processo CP87 on CP87.Num_proc = PS.Num_proc and CP87.Id_Campo = 87
					left Join  TErmo_PAgamento TP With(Nolock) on cast(TP.cd_termo as varchar(30))=P.payment
					where PS.Num_Proc = @Num_Proc
				)
		END	

		
	return @Valor

END






GO
