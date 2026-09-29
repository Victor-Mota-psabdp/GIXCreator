SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure spTemp

as

select Nome_tp_tx,FAT.cd_tp_Tx,vlr_pc Vlr_Pgto_Rcto_HIA,left(fatura_cc,16) Num_proc_Hia from fatura_chb_item FAT
Left Join Custo_Cliente CC on FAT.cd_Tp_Tx=CC.cd_tp_Tx and left(fatura_cc,16)=num_proc
Join Tipo_Taxa TT on TT.cd_tp_tx=FAT.cd_tp_Tx
where
	cc.num_proc is null and fatura_cc like '%DEC%'
	and (nome_tp_tx not like '%adiant%' and nome_Tp_Tx not like '%prest%' and nome_tp_tx not like '%Transf%')
	and fatura_cc in (select max(fatura_cc) from fatura_chb_item group by  left(fatura_cc,16))
GO
