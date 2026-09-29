SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spDocAnexados_Sel]--'Grupo FMC','2011-09-01','2011-09-29'

		@Grupo			Varchar(50),		
		@DtInicial		Datetime,
		@DtFinal		Datetime		

As

	Declare @cd_pes_grupo as varchar(10)
	Set @cd_pes_grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)
	set @grupo = (select grupo from grupo where cd_pes_grupo = @cd_pes_grupo)

	select 
		num_proc [JOB],
		anexado_em	[Sent Date],
		TC.nome_dc	[Tipo_Documento]
	from doc_anexos DA
		join tipo_doc_cliente TC on DA.id_dc = TC.id_dc	
	where 
		anexado_em between @DtInicial and @DtFinal
		and right(left(DA.Num_proc,5),3)  = @Grupo

order by num_proc



GO
