SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---ticket 100-355770
Create procedure [dbo].[spATL_NF_Integrada_Rel]  
 @Grupo varchar(20),  
 @dtInicial datetime,  
 @dtFinal datetime,  
 @nNF varchar(10),  
 @Num_Proc varchar(16)  
    
AS  

Declare @Cd_Grupo as varchar(10)
Set @Cd_Grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)


 select   
  CNPJ,  
  nNF [Nota Fiscal],Serie,convert(varchar(10),b.dEmis,103) [Data Emissão], b.Num_Proc [JOB],chNfe [Chave], convert(varchar(10),dt_alerta,103) [Data Envio XML]  
 from   
  ATL_BR.dbo.danfe_base B  
  left join ATL_BR.dbo.danfe_cia C on C.id_danfe = B.id_danfe and C.tipo = 'E'  
  left join vwClienteALLJOBS			HOU with(nolock) on HOU.num_proc = b.Num_Proc
  join pessoa					CNS with(nolock) on CNS.cd_pes = HOU.cd_cliente
  Left Outer Join Pessoa_LLP  PLL	with(nolock) on HOU.cd_cliente = PLL.Cd_Pes
  Left Outer Join Grupo		G	with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
  Left Outer Join pessoa		PG	with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
	
 where   
	convert(datetime,b.dEmis,103) between @DtInicial and @DtFinal
	and (PG.Apelido = @Grupo or @Grupo = 'GRUPO ALL')
	and b.dEmis >='2015-10-19'  
	and (b.nNF = @nNF OR @nNF = '' OR @nNF is NULL OR @nNF = '%')  
    and (b.Num_Proc like '%'+@Num_Proc+'%' OR @Num_Proc = '' OR @Num_Proc is NULL)  
 order by   
  dEmis, nNF  


GO
