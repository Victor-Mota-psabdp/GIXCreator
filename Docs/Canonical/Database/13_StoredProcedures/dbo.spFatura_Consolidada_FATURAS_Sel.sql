SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spFatura_Consolidada_FATURAS_Sel]--spFatura_Consolidada_FATURAS_Sel 'GRUPO OXITENO','I','2013-01-24','2013-04-24'
(
@Apelido		varchar(20),
@Tipo			varchar(1),
@DataInicial	datetime,
@DataFinal		datetime
)

AS

select IT.fatcod Referencia,IT. vlr_org from fatura_chb F
	join item_fat IT on F.fatura_PC = It.fatcod
	left join Fatura_Consolidada_Det FCD on FCD.fatcod = F.fatura_PC and id not in (select id from Fatura_Consolidada where ativo=0 and Fatura_Consolidada.id=FCD.id)
	join Pessoa_LLP PLL with(nolock) on PLL.Cd_Pes=F.Cd_pes_PC
	join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
	join pessoa	PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
where	
	cd_tp_tx in ('XCA','XCQ' ,'XEQ','XEU')
	and dc='C'	
	and Data_PC between @DataInicial and @DataFinal
	and Status_PC = 'E' and PG.APelido = @Apelido
	and IT.num_proc like @Tipo + '%'
	and FCD.fatcod is null
--	and FC.Ativo = 1



--select 
--	It.fatcod Referencia,IT. vlr_org 
--from 
--	item_fat IT
--	join fatura_CHB F on F.fatura_PC = It.fatcod	
--	left join Fatura_Consolidada_Det FCD on FCD.fatcod = It.fatcod and id not in (select top 1 id from Fatura_Consolidada where ativo=0 and Fatura_Consolidada.id=FCD.id)
----	left join Fatura_Consolidada FC on FC.ID = FCD.ID and ativo = 1	
--	join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=F.Cd_pes_PC
--	join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
--	join pessoa	PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
--	 where	
--	cd_tp_tx in ('XCA','XCQ' ,'XEQ','XEU')
--	and dc='C'	
--	and data_PC between @DataInicial and @DataFinal
--	and Status_PC = 'E' and PG.APelido = @Apelido
--	and IT.num_proc like @Tipo + '%'
--	and FCD.fatcod is null
----	and FC.Ativo = 1
--	
--

----select * from fatura_consolidada_det where id = 2
----
----[spFatura_Consolidada_FATURAS_Sel]'GRUPO OXITENO','I','2013-01-24','2013-04-25'

--ALTER procedure [dbo].[spFatura_Consolidada_FATURAS_Sel]--spFatura_Consolidada_FATURAS_Sel 'GRUPO OXITENO','I','2013-01-24','2013-04-24'
--(
--@Apelido		varchar(20),
--@Tipo			varchar(1),
--@DataInicial	datetime,
--@DataFinal		datetime
--)

--AS

--select 
--	It.fatcod Referencia,IT. vlr_org 
--from 
--	item_fat IT
--	join fatura_CHB F  with(nolock) on F.fatura_PC = It.fatcod	
--	left join Fatura_Consolidada_Det FCD  with(nolock) on FCD.fatcod = It.fatcod and id not in (select id from Fatura_Consolidada where ativo=0)
--	join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=F.Cd_pes_PC
--	join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
--	join pessoa	PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
--	Join Fatura FAT on FAT.fatcod=it.fatcod
-- where	
--	cd_tp_tx in ('XCA','XCQ' ,'XEQ','XEU')
--	and dc='C'	
--	and data_PC between @DataInicial and @DataFinal
--	and Status_PC = 'E' and PG.APelido = @Apelido
--	and IT.num_proc like @Tipo + '%'
--	and FCD.fatcod is null
----	and FC.Ativo = 1
--	and fatstatus <> 0



GO
