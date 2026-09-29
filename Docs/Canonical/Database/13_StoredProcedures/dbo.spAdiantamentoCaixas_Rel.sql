SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE procedure [dbo].[spAdiantamentoCaixas_Rel]
as
select
	Num_Proc_HIA Processo, Vlr_Pgto_Rcto_HIA Valor, Dt_Pgto_Rcto_HIA Data, cast(getdate() - convert(datetime,Dt_Pgto_Rcto_HIA,103) as int) Dias, nome_local Destino
from
	vwCXAS CX
	Left Join Fatura_CHB FC on Processo_PC = Num_Proc_HIA
	join house_exp_aer HEA on cx.num_proc_hia=hea.num_proc_hea
	join localidade L on hea.cd_org_hea = L.cd_local

where
	DC_HIA = 'C'
	and Cd_Tp_Tx like 'XB%'
	and convert(datetime,Dt_Pgto_Rcto_HIA ,103) < getdate() - 15
	and Fatura_PC is null
	and CX.Num_Proc_HIA like '%CSR%'

UNION

select
	Num_Proc_HIA Processo, Vlr_Pgto_Rcto_HIA Valor, Dt_Pgto_Rcto_HIA Data, cast(getdate() - convert(datetime,Dt_Pgto_Rcto_HIA,103) as int) Dias, nome_local Destino
from
	vwCXAS CX
	Left Join Fatura_CHB FC on Processo_PC = Num_Proc_HIA
	join house_exp_mar HEM on cx.num_proc_hia=hem.num_proc_hem
	join localidade L on hem.cd_org_hem = L.cd_local

where
	DC_HIA = 'C'
	and Cd_Tp_Tx like 'XB%'
	and convert(datetime,Dt_Pgto_Rcto_HIA ,103) < getdate() - 15
	and Fatura_PC is null
	and CX.Num_Proc_HIA like '%CSR%'

UNION

select
	Num_Proc_HIA Processo, Vlr_Pgto_Rcto_HIA Valor, Dt_Pgto_Rcto_HIA Data, cast(getdate() - convert(datetime,Dt_Pgto_Rcto_HIA,103) as int) Dias, nome_local Destino
from
	vwCXAS CX
	Left Join Fatura_CHB FC on Processo_PC = Num_Proc_HIA
	join house_exp_out HEO on cx.num_proc_hia = heo.num_proc_heo
	join localidade L on heo.cd_org_heo = L.cd_local

where
	DC_HIA = 'C'
	and Cd_Tp_Tx like 'XB%'
	and convert(datetime,Dt_Pgto_Rcto_HIA ,103) < getdate() - 15
	and Fatura_PC is null
	and CX.Num_Proc_HIA like '%CSR%'

UNION

select
	Num_Proc_HIA Processo, Vlr_Pgto_Rcto_HIA Valor, Dt_Pgto_Rcto_HIA Data, cast(getdate() - convert(datetime,Dt_Pgto_Rcto_HIA,103) as int) Dias, nome_local Destino
from
	vwCXAS CX
	Left Join Fatura_CHB FC on Processo_PC = Num_Proc_HIA
	join house_imp_mar HIM on cx.num_proc_hia = him.num_proc_him
	join localidade L on him.cd_dst_him = L.cd_local

where
	DC_HIA = 'C'
	and Cd_Tp_Tx like 'XB%'
	and convert(datetime,Dt_Pgto_Rcto_HIA ,103) < getdate() - 15
	and Fatura_PC is null
	and CX.Num_Proc_HIA like '%CSR%'

UNION

select
	Num_Proc_HIA Processo, Vlr_Pgto_Rcto_HIA Valor, Dt_Pgto_Rcto_HIA Data, cast(getdate() - convert(datetime,Dt_Pgto_Rcto_HIA,103) as int) Dias, nome_local Destino
from
	vwCXAS CX
	Left Join Fatura_CHB FC on Processo_PC = Num_Proc_HIA
	join house_imp_out HIO on cx.num_proc_hia = hio.num_proc_hio
	join localidade L on hio.cd_dst_hio = L.cd_local

where
	DC_HIA = 'C'
	and Cd_Tp_Tx like 'XB%'
	and convert(datetime,Dt_Pgto_Rcto_HIA ,103) < getdate() - 15
	and Fatura_PC is null
	and Num_Proc_HIA like '%CSR%'

UNION

select
	CX.Num_Proc_HIA Processo, Vlr_Pgto_Rcto_HIA Valor, Dt_Pgto_Rcto_HIA Data, cast(getdate() - convert(datetime,Dt_Pgto_Rcto_HIA,103) as int) Dias, nome_local Destino
from
	vwCXAS CX
	Left Join Fatura_CHB FC on Processo_PC = Num_Proc_HIA
	join house_imp_AER HIO on cx.num_proc_hia = hio.num_proc_hiA
	join localidade L on hio.cd_dst_hiA = L.cd_local

where
	DC_HIA = 'C'
	and Cd_Tp_Tx like 'XB%'
	and convert(datetime,Dt_Pgto_Rcto_HIA ,103) < getdate() - 15
	and Fatura_PC is null
	and CX.Num_Proc_HIA like '%CSR%'


order by 2
--	convert(datetime,Dt_Pgto_Rcto_HIA ,103)









GO
