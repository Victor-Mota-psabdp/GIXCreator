SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spEmix_JuntaPDF_Averbado_RE_Sel]

CREATE Procedure [dbo].[spEmix_JuntaPDF_Averbado_RE_Item_Sel]--'EMCSR201612108BR'
	@JOB varchar(16)

AS

select
	D.Nome_Arquivo
 from Doc_Anexos_Emix D with(nolock)
	Join Tarefas_Processos TP  with(nolock) on TP.Num_Proc = D.Num_Proc and ID_Task=15
where 
	Status = 'Averbado'
	and D.num_proc = @JOB
	and TP.Dt_Conclusao is not null

--select * from Tipo_Doc_Cliente
--4	RE Number
GO
