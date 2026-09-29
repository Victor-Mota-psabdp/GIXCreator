SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Function [dbo].[fBuscaSaldoCaixaSemServicos_Sel] (
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
					return (select sum(dbo.valor(vlr_pgto_rcto_hia,dc_hia)) Saldo From vwcxas CXA 
							--Join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=CXA.cd_Tp_Tx and repasse_tx='S'
							where num_proc_hia=@num_proc and not(cxa.cd_tp_tx not in ('P01','PIS','C01','CF1','ORE','TTC','BRO','SRV','ERE','NFE','GPI','GPO','IRR','IRR'))
							
							)
				End

			if Left(@Num_Proc,2)='EM'
				Begin
					return (select sum(dbo.valor(vlr_pgto_rcto_hia,dc_hia)) Saldo From vwcxas CXA 
							--Join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=CXA.cd_Tp_Tx and repasse_tx='S'
							where num_proc_hia=@num_proc and not(cxa.cd_tp_tx  not in ('P01','PIS','C01','CF1','ORE','TTC','BRO','SRV','ERE','NFE','GPI','GPO','IRR')))
				End

			if Left(@Num_Proc,2)='IA'
				Begin
					return (select sum(dbo.valor(vlr_pgto_rcto_hia,dc_hia)) Saldo From vwcxas CXA 
					--Join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=CXA.cd_Tp_Tx and repasse_tx='S'
					
					where num_proc_hia=@num_proc and not(cxa.cd_tp_tx  not in ('P01','PIS','C01','CF1','ORE','TTC','BRO','SRV','ERE','NFE','GPI','GPO','IRR')))
				End

			if Left(@Num_Proc,2)='IO'
				Begin
					return (select sum(dbo.valor(vlr_pgto_rcto_hia,dc_hia)) Saldo From vwcxas CXA 
					--Join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=CXA.cd_Tp_Tx and repasse_tx='S'
					where num_proc_hia=@num_proc and not(cxa.cd_tp_tx  not in ('P01','PIS','C01','CF1','ORE','TTC','BRO','SRV','ERE','NFE','GPI','GPO','IRR')))
				End

			if Left(@Num_Proc,2)='EO'
				Begin
					return (select sum(dbo.valor(vlr_pgto_rcto_hia,dc_hia)) Saldo From vwcxas CXA 
					
					--Join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=CXA.cd_Tp_Tx and repasse_tx='S'
					where num_proc_hia=@num_proc and not(cxa.cd_tp_tx  not in ('P01','BRO','SRV','ERE','NFE','GPI','GPO','IRR')))
				End

		End
	Else
				Begin
					return (select sum(dbo.valor(vlr_pgto_rcto_hia,dc_hia)) Saldo From vwcxas CXA 
					--Join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=CXA.cd_Tp_Tx and repasse_tx='S'	
					where num_proc_hia=@num_proc and not(cxa.cd_tp_tx  in ('P01','PIS','C01','CF1','ORE','TTC','BRO','SRV','ERE','NFE','GPI','GPO','IRR')))
				End


	return 0
End



GO
