SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spCHBDebito_CC 'IMSTL21509006BR'

CREATE   procedure [dbo].[spCHBDebito_CC]-- 'IMCSR21509001BR'

	@num_proc 	varchar(16)
as

if len(@Num_proc) = 16
	begin
		select 
			CC.Cd_Tp_TX, Nome_tp_tx,sum(vlr_item_custo) Valor,'D' DC, Prestacao  from custo_cliente CC
		Join tipo_Taxa TT on TT.cd_tp_tx=CC.cd_tp_tx
		Left join vwcta_Cte CTA on CTA.num_proc_hia=CC.num_proc and CTA.cd_tp_tx=CC.cd_tp_tx and ((CTA.dc_hia='C' and left(cta.cd_tp_tx,1)<>'X') or (Cta.dc_hia='D' and left(cta.cd_tp_tx,1)='X'))
		Left Join vwFaturasValidasCHB ITT with (nolock) on itt.Num_Proc=CC.num_proc  and itt.cd_tp_Tx=CC.cd_tp_tx and ((itt.DC='C' and left(itt.cd_tp_tx,1)<>'X') or (itt.DC='D' and left(itt.cd_tp_tx,1)='X'))
		Where 
			CC.Num_Proc=@Num_Proc   
			AND (Prestacao = 'S' or Prestacao is Null) 
			AND  CTA.DC_HIA IS NULL 
			and CC.cd_tp_tx not in ('XBA', 'XBC')
			and itt.FatCod is null
		group by nome_tp_tx,cta.dc_hia,CC.cd_tp_tx, Prestacao
	end
else
	begin
	select CC.Cd_Tp_TX, Nome_tp_tx,sum(Valor) Valor,'D' DC  from custo_processo CC
		Join tipo_Taxa TT on TT.cd_tp_tx=CC.cd_tp_tx
		Left join vwcta_Cte CTA on CTA.num_proc_hia=CC.num_proc and CTA.cd_tp_tx=CC.cd_tp_tx and ((CTA.dc_hia='C' and left(cta.cd_tp_tx,1)<>'X') or (Cta.dc_hia='D' and left(cta.cd_tp_tx,1)='X'))
		Left Join vwFaturasValidasCHB ITT with (nolock) on itt.Num_Proc=CC.num_proc  and itt.cd_tp_Tx=CC.cd_tp_tx and ((itt.DC='C' and left(itt.cd_tp_tx,1)<>'X') or (itt.DC='D' and left(itt.cd_tp_tx,1)='X'))
	Where 
		CC.Num_Proc=@Num_Proc AND  CTA.DC_HIA IS NULL and CC.cd_tp_tx not in ('XBA', 'XBC')
		and itt.FatCod is null
	group by nome_tp_tx,cta.dc_hia,CC.cd_tp_tx
	end




/*Velha
ALTER   procedure [dbo].[spCHBDebito_CC]
	@num_proc 	varchar(16)
as


if len(@Num_proc) = 16
	begin
	--select CC.Cd_Tp_TX, Nome_tp_tx,sum(vlr_item_custo) Valor,cta.dc_hia DC, Prestacao  from custo_cliente CC	
	select CC.Cd_Tp_TX, Nome_tp_tx,sum(vlr_item_custo) Valor,'D' DC, Prestacao  from custo_cliente CC	
	Join tipo_Taxa TT on TT.cd_tp_tx=CC.cd_tp_tx
	Left join vwcta_Cte CTA on CTA.num_proc_hia=CC.num_proc and CTA.cd_tp_tx=CC.cd_tp_tx and ((CTA.dc_hia='C' and left(cta.cd_tp_tx,1)<>'X') or (Cta.dc_hia='D' and left(cta.cd_tp_tx,1)='X'))
	Where num_proc=@Num_Proc   AND (Prestacao = 'S' or Prestacao is Null) AND  CTA.DC_HIA IS NULL and CC.cd_tp_tx not in ('XBA', 'XBC')
	group by nome_tp_tx,cta.dc_hia,CC.cd_tp_tx, Prestacao
	end
else
	begin
	--select CC.Cd_Tp_TX, Nome_tp_tx,sum(Valor) Valor,cta.dc_hia DC  from custo_processo CC
	select CC.Cd_Tp_TX, Nome_tp_tx,sum(Valor) Valor,'D' DC  from custo_processo CC
	Join tipo_Taxa TT on TT.cd_tp_tx=CC.cd_tp_tx
	Left join vwcta_Cte CTA on CTA.num_proc_hia=CC.num_proc and CTA.cd_tp_tx=CC.cd_tp_tx and ((CTA.dc_hia='C' and left(cta.cd_tp_tx,1)<>'X') or (Cta.dc_hia='D' and left(cta.cd_tp_tx,1)='X'))
	Where num_proc=@Num_Proc AND  CTA.DC_HIA IS NULL and CC.cd_tp_tx not in ('XBA', 'XBC')
	group by nome_tp_tx,cta.dc_hia,CC.cd_tp_tx
	end

*/




GO
