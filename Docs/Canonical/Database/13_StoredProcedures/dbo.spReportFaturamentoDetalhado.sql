SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[spReportFaturamentoDetalhado] 
	
			@Num_NF			Varchar(10),
			@Ref_Acesso		Varchar(20)

as
select 
	F.fatura_cc [Job], 
	dbo.fBusca_TipoDocCliente('N',I.Num_Proc_HIA,3) [PO],
	A.MAWB, 
	A.HAWB,
	T.nome_tp_tx [Taxa],
	F.Vlr_PC [valor] 
from vwcta_Cte I	
	join fatura_chb FC on FC.Processo_PC = I.Num_Proc_HIA
	join Fatura_CHB_Item F on FC.fatura_pc = F.fatura_cc
	join Tipo_taxa T on T.cd_tp_tx = F.cd_tp_tx and T.Nome_Tp_Tx not like 'Adianta%'
	join vwCliente_Alerta A on A.num_proc = I.Num_Proc_HIA
where 
	I.Num_NF_HIA = @Num_NF and I.Ref_Acesso_NF_HIA = @Ref_Acesso
	and F.Tp_Pgto = 'B'
	and FC.status_pc = 'E'
order by 1 


















GO
