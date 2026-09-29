SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_FollowUpAMZ_Rel 'EMAMZ201603006BR'
CREATE procedure spATL_FollowUpAMZ_Rel
(
@Num_Proc Varchar(16)
)
as

select 
	HOU.Num_Proc,
	EX.Nome_Raz_Soc [Exportador],
	IM.Nome_Raz_Soc [Importador],
	(Case when SUBSTRING(HOU.num_proc,2,1) = 'A' then CIa.Nome_Cia_Aer else
	Ar.Nome_Armador End) [Cia\Armador],
	INC.Nome_Tp_Oper [Incoterms],
	dbo.fBusca_Docs_PO_Modal_COALESCE(HOU.Num_proc,'2') [Invoice],
	Org.Nome_Local [Origem],
	Dest.Nome_Local [Destino],
	HOU.HAWB,
	HOU.ETD,
	HOU.ATD,
	HOU.ETA,
	HOU.ATA,
	(Case when SUBSTRING(HOU.num_proc,2,1) = 'O' then TRP.Apelido else Hou.Vessel End) [Dados do Embarque],
	HOU.Qtd_Vol,
	HOU.Peso_Bruto,
	HOU.Peso_Liquido,
	HG.HSGData,
	HG.HSDDescricao
	
	--(Case when SUBSTRING(HOU.num_proc,2,1) = 'A' then Hou.Vessel  else 
	--Ar.Nome_Armador End) [Dados do Embarque]
from 
	vwHouse_EXP HOU with(nolock)
left join Tarefas_Processos TP40 with(nolock) on HOU.Num_Proc = TP40.Num_Proc and TP40.ID_Task = 40
join Pessoa EX with(nolock) on HOU.Cd_Export = Ex.Cd_Pes
join Pessoa_LLP PL with(nolock) on EX.Cd_Pes = PL.Cd_Pes
join Grupo GP with(nolock) on PL.Cd_Pes_Grupo = GP.Cd_Pes_Grupo
join Pessoa IM with(nolock) on HOU.Cd_Consig = IM.Cd_Pes
left join Cia_Aerea CIA with(nolock) on HOU.Cd_Armador = CIA.Cd_Cia_Aer
left join Armador AR with(nolock) on HOU.Cd_Armador = AR.Cd_Armador
left join Tipo_Oper INC with(nolock) on HOU.Cd_Tp_Oper = INC.Cd_Tp_Oper
left join Localidade Dest with(nolock) on HOU.Cd_Dst = Dest.Cd_Local
left join Localidade Org with(nolock) on HOU.Cd_Org = Org.Cd_Local
left join Pessoa TRP with(nolock) on HOU.Cd_Transportadora = TRP.cd_pes
left join Hist_Geral HG with(nolock) on HOu.Num_Proc = HG.HSGProcesso and HG.Disp_Cliente = 'S'
where GP.Grupo = 'AMZ'  and HOU.Num_Proc = @Num_Proc --and TP40.Dt_Conclusao is null 
union
select 
	HOU.Num_Proc,
	IM.Nome_Raz_Soc [Exportador],
	EX.Nome_Raz_Soc [Importador],
	(Case when SUBSTRING(HOU.num_proc,2,1) = 'A' then CIa.Nome_Cia_Aer else
	Ar.Nome_Armador End) [Cia\Armador],
	INC.Nome_Tp_Oper [Incoterms],
	dbo.fBusca_Docs_PO_Modal_COALESCE(HOU.Num_proc,'2') [Invoice],
	Org.Nome_Local [Origem],
	Dest.Nome_Local [Destino],
	HOU.HAWB,
	HOU.ETD,
	HOU.ATD,
	HOU.ETA,
	HOU.ATA,
	(Case when SUBSTRING(HOU.num_proc,2,1) = 'O' then TRP.Apelido else Hou.Vessel End) [Dados do Embarque],
	HOU.Qtd_Vol,
	HOU.Peso_Bruto,
	HOU.Peso_Liquido,
	HG.HSGData,
	HG.HSDDescricao
	
	--(Case when SUBSTRING(HOU.num_proc,2,1) = 'A' then Hou.Vessel  else 
	--Ar.Nome_Armador End) [Dados do Embarque]
from 
	vwHouse_IMP HOU with(nolock)
left join Tarefas_Processos TP40 with(nolock) on HOU.Num_Proc = TP40.Num_Proc and TP40.ID_Task = 40
join Pessoa EX with(nolock) on HOU.Cd_Consig = Ex.Cd_Pes
join Pessoa_LLP PL with(nolock) on EX.Cd_Pes = PL.Cd_Pes
join Grupo GP with(nolock) on PL.Cd_Pes_Grupo = GP.Cd_Pes_Grupo
join Pessoa IM with(nolock) on HOU.Cd_Export = IM.Cd_Pes
left join Cia_Aerea CIA with(nolock) on HOU.Cd_Armador = CIA.Cd_Cia_Aer
left join Armador AR with(nolock) on HOU.Cd_Armador = AR.Cd_Armador
left join Tipo_Oper INC with(nolock) on HOU.Cd_Tp_Oper = INC.Cd_Tp_Oper
left join Localidade Dest with(nolock) on HOU.Cd_Dst = Dest.Cd_Local
left join Localidade Org with(nolock) on HOU.Cd_Org = Org.Cd_Local
left join Pessoa TRP with(nolock) on HOU.Cd_Transportadora = TRP.cd_pes
left join Hist_Geral HG with(nolock) on HOu.Num_Proc = HG.HSGProcesso and HG.Disp_Cliente = 'S'
where GP.Grupo = 'AMZ' and HOU.Num_Proc = @Num_Proc -- and TP40.Dt_Conclusao is null 



--select * from tipo_tarefas
--where Nome_Task like '%prest%'

-- Tipo_Ocorrencia
--where Cd_Tp_Ocor = '400'

--where Nome_Tp_Ocor lik '%Envio%'

-- Tipo_Ocorrencia
--select '400','Envio da Prestação de Contas','N',NULL
GO
