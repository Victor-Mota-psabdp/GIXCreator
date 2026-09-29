SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spATL_Tipo_NC_Cliente_Sel]

	@HSGProcesso	VarChar(16),
	@Shipper		varchar(50)
as
	
Declare @cd_pes		varchar(20)
set @cd_pes = (select cd_pes from pessoa where Apelido = @Shipper)
 
Declare @cd_pes_grupo varchar(10)
Set @cd_pes_grupo = (select cd_pes_grupo from grupo where grupo = right(left(@HSGProcesso,5),3))


select Descricao_NC 
	from Tipo_NC_Cliente 
where Ativo = 'S'and (Cd_Pes_Grupo = @Cd_Pes_Grupo or Cd_Pes_Grupo = '10017')

GO
