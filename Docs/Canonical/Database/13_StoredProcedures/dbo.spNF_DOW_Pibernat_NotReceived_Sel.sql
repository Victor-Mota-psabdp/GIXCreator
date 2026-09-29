SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spNF_DOW_Pibernat_NotReceived_Sel]--'Grupo Dow'
(
	@Grupo varchar(25)
	--,
	--@Initial_Date datetime,
	--@End_Date datetime
)
	 
AS

select HOU.num_proc [JOB], T4.DT_Conclusao [Desembaraco],DA.nNF [NF], PO.NUmero_DI [DI] from vwHouse_Imp HOU with (nolock)
	join Pessoa_LLP LLP with (nolock) on LLP.cd_pes = HOU.cd_consig 
	join Pessoa P on P.cd_pes = LLP.cd_pes_grupo
	JOIN Tarefas_Processos T4 with (nolock) on T4.num_proc = HOU.num_proc and t4.id_task = 4
	left Join ATL_BR.dbo.danfe_base DA with (nolock) on DA.num_proc = HOU.num_proc	
	left join vwPO_Imp PO on PO.num_proc = HOU.num_proc
Where 
	T4.DT_Conclusao between getdate() -120 and getdate() -2	and
	cd_dst in ('ITJ','GIG','NVT','URG','IOA','IGI','RIG')
	and DA.nNF is NULL
	--and LLP.cd_pes_grupo = '1'
	and P.Apelido = @Grupo
order by 2


--Grupo:  DOW
--Constar no report: JOB com Desembaraço + 3 sem XML recebido
--Destinos:
--Itajaí
--Rio de Janeiro
--Navegantes
--Uruguaiana
--Itapoa
--ITAGUAI
--Rio Grande

--ITJ	Itajaí
--GIG	Rio de Janeiro
--NVT	Navegantes
--URG	Uruguaiana
--IOA	Itapoa
--IGI	ITAGUAI
--RIG	Rio Grande
GO
