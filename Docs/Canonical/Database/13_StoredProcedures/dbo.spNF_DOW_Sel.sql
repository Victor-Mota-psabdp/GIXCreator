SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--marcela alter proc 100-182106 
--use atlantis
--spNF_DOW_Sel 'CSR','','','',''  
CREATE procedure [dbo].[spNF_DOW_Sel]  
 @Grupo varchar(3),  
 @dtInicial datetime,  
 @dtFinal datetime,  
 @nNF varchar(10),  
 @Num_Proc varchar(16)  
    
AS  

 --IF @dtInicial is NULL Relaciona as NF do mês corrente em que se executa a stored  
 if @dtInicial is NULL or @dtInicial = ''  
  begin  
     
   set @dtInicial = cast(year(DATEADD(m,-1,getdate())) as varchar(4)) + '-' + cast(month(DATEADD(m,-1,getdate())) as varchar(2)) + '-' + '01'  
   
   --set @dtInicial = cast(year(getdate()) as varchar(4)) + '-' + cast(month(getdate()) as varchar(2)) + '-' + '01'  
  
   set @dtFinal = getdate()  
  end  
 --print  @dtInicial  
 --print @dtFinal 

 update ATL_BR.dbo.danfe_base set dt_alerta = getdate()  
 where  substring(num_proc,3,3) = @Grupo  
  and dEmis >='2015-10-19'  
  and dEmis between @dtInicial and @dtFinal   
    
  and (nNF = @nNF OR @nNF = '' OR @nNF is NULL OR @nNF = '%')  
  and (Num_Proc like '%'+@Num_Proc+'%' OR @Num_Proc = '' OR @Num_Proc is NULL)   
  and dt_Alerta is NULL  
    

 select   
  CNPJ,  
  nNF [Nota Fiscal],Serie,convert(varchar(10),dEmis,103) [Data Emissão], Num_Proc [JOB],chNfe [Chave], convert(varchar(10),dt_alerta,103) [Data Envio XML]  
  --(case   
  -- when dtCancel is NOT null and dtEnvioEsc is NOT null then 'Disponibilizada para Escrituração como CANCELADA'  
  -- when dtEnvioEsc is NOT NULL then 'Disponibilizada para Escrituração'   
  -- else ''   
  --end) [STATUS],  
  --NULL [Disponivel_em],  
  --dtEnvioEsc[Disponivel_em],  
  -- 'br.sao.sistemas@bdpint.com;cristiane.martins@bdpint.com;keity.lira@bdpint.com;rafael.ferreira@bdpint.com;bruno.brianeze@bdpint.com' Emails  
 from   
  ATL_BR.dbo.danfe_base B  
  left join ATL_BR.dbo.danfe_cia C on C.id_danfe = B.id_danfe and C.tipo = 'E'  
  --left join ATL_BR.dbo.danfe_totais DT on B.Id_danfe = DT.Id_Danfe and vICMS = 0 and vIPI = 0 and vPIS = 0 and vCofins =0  
 where   
  substring(num_proc,3,3) = @Grupo  
  /**/
  and dEmis >='2015-10-19'  
  --and dEmis between @dtInicial and @dtFinal   
    and (dEmis between @dtInicial and @dtFinal or @dtInicial = '' or @dtInicial is null or @dtFinal = '' or @dtFinal is null ) 

  and (nNF = @nNF OR @nNF = '' OR @nNF is NULL OR @nNF = '%')  
  

  and (Num_Proc like '%'+@Num_Proc+'%' OR @Num_Proc = '' OR @Num_Proc is NULL)  
  --and nNF in('8308','8309','8310','8311','8312')  
  --and nNF <> '6374' and nNF <>'6392'  
   
   ----Alessandra 29/07/2020
   --and dt_Alerta is NULL  
 order by   
  dEmis, nNF  



GO
