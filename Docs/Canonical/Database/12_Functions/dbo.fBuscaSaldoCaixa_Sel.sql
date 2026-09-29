SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE Function [dbo].[fBuscaSaldoCaixa_Sel] (
		@Num_proc	varchar(16)
	)
returnS
Decimal(10,2)
as
Begin
	if len(@Num_proc)=16 
		Begin
			if Left(@Num_Proc,2)='IM'
				Begin
					return (select sum(dbo.valor(vlr_pgto_rcto_him,dc_him)) Saldo From caixa_hou_imp_mar with(nolock) where num_proc_him=@num_proc)
				End

			if Left(@Num_Proc,2)='EM'
				Begin
					return (select sum(dbo.valor(vlr_pgto_rcto_hem,dc_hem)) Saldo From caixa_hou_exp_mar where num_proc_hem=@num_proc)
				End

			if Left(@Num_Proc,2)='IA'
				Begin
					return (select sum(dbo.valor(vlr_pgto_rcto_hia,dc_hia)) Saldo From caixa_hou_imp_aer where num_proc_hia=@num_proc)
				End

			if Left(@Num_Proc,2)='IO'
				Begin
					return (select sum(dbo.valor(vlr_pgto_rcto_hio,dc_hio)) Saldo From caixa_hou_imp_out where num_proc_hio=@num_proc)
				End

			if Left(@Num_Proc,2)='EO'
				Begin
					return (select sum(dbo.valor(vlr_pgto_rcto_heo,dc_heo)) Saldo From caixa_hou_exp_out where num_proc_heo=@num_proc)
				End

		End
	Else
				Begin
					return (select sum(dbo.valor(vlr_pgto_rcto_hia,dc_hia)) Saldo From vwcxas where num_proc_hia=@num_proc)
				End


	return 0
End


GO
