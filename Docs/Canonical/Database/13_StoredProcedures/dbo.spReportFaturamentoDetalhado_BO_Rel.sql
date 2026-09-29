SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----select * from vwcta_cte where num_proc_hia ='IMCSR202105324BR' and num_nf_hia = '108802'
----select * from fatura_chb where Processo_PC like '%IMCSR202105324BR%'
----select * from vwFaturasValidasCHB where Num_Proc='IMCSR202103711BR'

----NFe 108795 
----RPS 108802 
----Filial Santos
----Total que deve aparecer no Report R$ 41.722,20

----select *from vwFaturasValidasCHB_Tp_Pgto F
----	join tipo_taxa t on t.cd_tp_tx = F.cd_tp_tx
----where Num_Proc='IMCSR202105324BR' and tp_Pgto = 'B'		

----[spReportFaturamentoDetalhado_Rel] 'IOSWB202102006BR'
---- and fc.cd_tipo = 'P' para só trazer a principal
--select * from vwCliente_Alerta where num_proc = 'BOCSR202008051BR'
--select * from pessoa where cd_pes = 'P000015511'
--select * from pessoa_llp where cd_pes = 'P000015511'
--select * from vwcta_Cte where num_proc_hia = 'BOCSR202008051BR'

--select * from vwcta_Cte where num_nf_hia = '5640' and ref_acesso_nf_hia ='K'

--select * from fatura where fatcod like 'BOCSR202008051BR%'
--select * from fatura_chb where fatura_pc like 'BOCSR202008051BR%'
--select * from Fatura_CHB_Item where fatura_cc like 'BOCSR202008051BR%'
--vwCliente_Alerta
--select * from report

--025 - Requerimento
CREATE Procedure [dbo].[spReportFaturamentoDetalhado_BO_Rel]--'Grupo Dow','2021-07-01'
(
	@Group_Name	varchar(50),
	@Data	Datetime
)

as


Declare @Cd_Grupo as varchar(10)
Set @Cd_Grupo = (select top 1 Cd_Pes from pessoa where apelido='Grupo DOw')


select 
	'Job ' + F.fatura_cc [Job], 
	'PO ' + isnull(dbo.fBusca_TipoDocCliente('N',FC.Processo_PC,3),'') [PO],
	'MBL ' + isnull(A.MAWB,'')  MAWB,
	'HBL ' + isnull(A.HAWB,'')  HAWB,
	T.nome_tp_tx [Taxa], 
	F.Vlr_PC [valor]
from fatura_chb FC		
	join Fatura_CHB_Item F on FC.fatura_pc = F.fatura_cc
	join Tipo_taxa T on T.cd_tp_tx = F.cd_tp_tx and T.Nome_Tp_Tx not like 'Adianta%'	
	left join JOB_HBO BO on BO.num_proc_HBO = FC.Processo_PC
	left join vwCliente_Alerta A on A.num_proc = BO.num_proc
	--left join Pessoa_LLP P on P.cd_pes = A.cd_cliente and P.cd_pes_grupo = @Cd_Grupo
where 
	FC.fatura_pc like 'BO%'
	and	F.Tp_Pgto = 'B'
	and FC.status_pc = 'E'
	and fc.data_pc > '2021-07-01'
	and fc.cd_tipo = 'P'
order by 1 


















GO
