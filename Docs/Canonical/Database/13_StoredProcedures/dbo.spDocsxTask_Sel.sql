SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spDocsxTask_Sel]'ALL'
CREATE Procedure [dbo].[spDocsxTask_Sel]--ALL
	@all varchar(3)
as

select distinct 
	ID,
	right('000'+cast(TD.ID_DC as varchar),3) + ' - ' + TD.Nome_DC [Documento], 
	right('000'+cast(TT.ID_Task as varchar),3)+ ' - ' +TT.Nome_Task [Task],
	DT.Modal,
	(case when DT.ID_PD = '0' then
		'0 - ALL'
	else
		right('000'+cast(B.ID_PD as varchar),3) + ' - ' + B.Nome_BDP_Produto 
	end) [BDP Product]
from Doc_Tarefas DT
	--join Tipo_Doc_Cliente TD with(nolock) on DT.ID_DC = TD.ID_DC 
	join Tipo_Doc_Cliente TD with(nolock) on cast(TD.Id_DC as varchar(50)) = DT.ID_DC and cast(DT.ID_DC as varchar(50)) not like '%,%'	
	join Tipo_Tarefas TT with(nolock) on DT.ID_Task = TT.ID_Task and TT.Modal = DT.Modal
	left join BDP_Produto B with(nolock) on B.ID_PD = DT.ID_PD
		
union all

select distinct 
	DT.ID,
	[dbo].[FBusca_Doc_Tarefas_DocName](DT.ID) [Documento], 
	right('000'+cast(TT.ID_Task as varchar),3)+ ' - ' +TT.Nome_Task [Task],
	DT.Modal,
	(case when DT.ID_PD = '0' then
		'0 - ALL'
	else
		right('000'+cast(B.ID_PD as varchar),3) + ' - ' + B.Nome_BDP_Produto 
	end) [BDP Product]
from Doc_Tarefas DT
	--join Tipo_Doc_Cliente TD with(nolock) on TD.ID_DC like '%,%'
	join Tipo_Tarefas TT with(nolock) on DT.ID_Task = TT.ID_Task and TT.Modal = DT.Modal
	left join BDP_Produto B with(nolock) on B.ID_PD = DT.ID_PD
where
	DT.ID_DC like '%,%'
order by 2,3, Modal	


	

GO
