SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
--o antigo era [spATL_NFPorGrupoV2_Rel]  
--[spATL_NFPorGrupoV4_Rel] ''  
CREATE Procedure [dbo].[spATL_NFPorGrupoV5_Rel]--''--GRUPO SPECO' --[dbo].[spATL_NFPorGrupoV4_Rel] 'GRUPO SPECO'  
 @Grupo varchar(50)  
 ,@Year as int   
AS  

  
Declare @Resultado Table  
  (  
   Modal  Varchar(2),  
   Grupo  Varchar(50),  
   Empresa  Varchar(100)  
  )  
  
Declare @ResultadoFinal Table  
  (  
   Modal  Varchar(2),  
   Grupo  Varchar(50),  
   Empresa  Varchar(100),  
   --Janeiro  Decimal(10,2) Default 0,  
   [Janeiro Gross Revenue Total] Decimal(10,2) Default 0,  
   [Janeiro Gross Revenue CHB]  Decimal(10,2) Default 0,  
   [Janeiro Gross Revenue Transp] Decimal(10,2) Default 0,  
   JaneiroJOB int Default 0,  
   --Fevereiro Decimal(10,2) Default 0,  
   [Fevereiro Gross Revenue Total] Decimal(10,2) Default 0,  
   [Fevereiro Gross Revenue CHB]  Decimal(10,2) Default 0,  
   [Fevereiro Gross Revenue Transp] Decimal(10,2) Default 0,  
   FevereiroJOB int Default 0,  
   --Marco  Decimal(10,2) Default 0,  
   [Marco Gross Revenue Total] Decimal(10,2) Default 0,  
   [Marco Gross Revenue CHB]  Decimal(10,2) Default 0,  
   [Marco Gross Revenue Transp] Decimal(10,2) Default 0,  
   MarcoJOB int Default 0,  
   --Abril  Decimal(10,2) Default 0,  
   [Abril Gross Revenue Total] Decimal(10,2) Default 0,  
   [Abril Gross Revenue CHB]  Decimal(10,2) Default 0,  
   [Abril Gross Revenue Transp] Decimal(10,2) Default 0,  
   AbrilJOB int Default 0,  
   --Maio  Decimal(10,2) Default 0,  
   [Maio Gross Revenue Total] Decimal(10,2) Default 0,  
   [Maio Gross Revenue CHB]  Decimal(10,2) Default 0,  
   [Maio Gross Revenue Transp] Decimal(10,2) Default 0,  
   MaioJOB int Default 0,  
   --Junho  Decimal(10,2) Default 0,  
   [Junho Gross Revenue Total] Decimal(10,2) Default 0,  
   [Junho Gross Revenue CHB]  Decimal(10,2) Default 0,  
   [Junho Gross Revenue Transp] Decimal(10,2) Default 0,  
   JunhoJOB int Default 0,  
   --Julho  Decimal(10,2) Default 0,  
   [Julho Gross Revenue Total] Decimal(10,2) Default 0,  
   [Julho Gross Revenue CHB]  Decimal(10,2) Default 0,  
   [Julho Gross Revenue Transp] Decimal(10,2) Default 0,  
   JulhoJOB int Default 0,  
   --Agosto  Decimal(10,2) Default 0,  
   [Agosto Gross Revenue Total] Decimal(10,2) Default 0,  
   [Agosto Gross Revenue CHB]  Decimal(10,2) Default 0,  
   [Agosto Gross Revenue Transp] Decimal(10,2) Default 0,  
   AgostoJOB int Default 0,  
   --Setembro Decimal(10,2) Default 0,  
   [Setembro Gross Revenue Total] Decimal(10,2) Default 0,  
   [Setembro Gross Revenue CHB]  Decimal(10,2) Default 0,  
   [Setembro Gross Revenue Transp] Decimal(10,2) Default 0,  
   SetembroJOB int Default 0,  
   --Outubro  Decimal(10,2) Default 0,  
   [Outubro Gross Revenue Total] Decimal(10,2) Default 0,  
   [Outubro Gross Revenue CHB]  Decimal(10,2) Default 0,  
   [Outubro Gross Revenue Transp] Decimal(10,2) Default 0,  
   OutubroJOB int Default 0,   
   --Novembro Decimal(10,2) Default 0,  
   [Novembro Gross Revenue Total] Decimal(10,2) Default 0,  
   [Novembro Gross Revenue CHB] Decimal(10,2) Default 0,  
   [Novembro Gross Revenue Transp] Decimal(10,2) Default 0,  
   NovembroJOB int Default 0,  
   --Dezembro Decimal(10,2) Default 0,  
   [Dezembro Gross Revenue Total] Decimal(10,2) Default 0,  
   [Dezembro Gross Revenue CHB] Decimal(10,2) Default 0,  
   [Dezembro Gross Revenue Transp] Decimal(10,2) Default 0,  
   DezembroJOB int Default 0  
  )  
  
Declare @ResultadoTemp Table  
  (  
   JOB varchar(16),  
   Cd_tp_tx varchar(6),  
   DC varchar(1),  
   Tipo_Prod_Code varchar(1),  
   Modal Varchar(2),  
   Grupo Varchar(50),  
   Empresa Varchar(100),  
   [Gross Revenue Total] float,  
   [Gross Revenue CHB]  float,  
   [Gross Revenue Transp] float,  
   Jobs int,  
   Mes  int  
  )  
  
if @Grupo = ''   
 begin  
  Set @Grupo = 'ALL'  
 End  
  
Insert @ResultadoTemp  
 select  
  CTA.Num_proc,  
  CTA.Cd_Tp_Tx,  
  CTA.DC,  
  TT.Tipo_Prod_Code,   
  left(CTA.Num_proc,2)[Modal],  
  (Case when @Grupo ='GRUPO DOW' then  
   (Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)  
  else PP.Apelido end) Grupo,  
  CLI.Nome_Raz_Soc Empresa,   
      
  sum(dbo.valor(Valor_ARP,DC))[Gross Revenue Total], --Total NF do JOB  
        
  (case when TT.Tipo_Prod_Code = 1 then  
   sum(dbo.valor(Valor_ARP,DC))    
  end) [Gross Revenue CHB],--Soma dos itens da NF q tem Tipo Taxa CHB  
  
  (case when isnull(TT.Tipo_Prod_Code,2) <> 1 then  
   sum(dbo.valor(Valor_ARP,DC))    
  end) [Gross Revenue Transp], --ambos e não chb    
     
  count(distinct CTA.Num_proc)JOBs,  
  month(Dt_Fatura) Mes  
 from   
  vwFaturasValidasArg CTA  with(nolock)  
  Join Tipo_Taxa TT   with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx  
  Join vwClienteALLJOBS hou with(nolock) on hou.num_proc=CTA.Num_Proc  
  Join Pessoa CLI    with(nolock) on HOU.cd_cliente=CLI.cd_pes  
  left Join Pessoa_LLP PLLP with(nolock) on HOU.cd_cliente=PLLP.cd_pes  
  left Join Pessoa PP   with(nolock) on PP.cd_pes=cd_pes_grupo      
 Where  
  --year(Dt_Fatura)=YEAR(getdate())  
  year(Dt_Fatura)=@year  
  and Dt_Fatura <=getdate()  
  --and month(dt_fatura) = @Mes  
  and (PP.Apelido = @Grupo or @Grupo  = 'ALL')  
 Group by   
   CLI.Nome_Raz_Soc,CLI.Apelido,PP.Apelido,HOU.Num_proc,  
   TT.Tipo_Prod_Code,Dt_Fatura  
   ,CTA.Num_proc,CTA.Cd_Tp_Tx,CTA.DC  
    
UNION ALL  
 --Master  
 select  
  CTA.Num_proc,  
  CTA.Cd_Tp_Tx,  
  CTA.DC,  
  TT.Tipo_Prod_Code,   
  left(CTA.Num_proc,2)[Modal],  
  (Case when @Grupo ='GRUPO DOW' then  
   (Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)   
  else PP.Apelido end) Grupo,  
  CLI.Nome_Raz_Soc Empresa,  
      
  sum(dbo.valor(Valor_ARP,DC))[Gross Revenue Total], --Total NF do JOB  
      
  (case when TT.Tipo_Prod_Code = 1 then  
   sum(dbo.valor(Valor_ARP,DC))    
  end) [Gross Revenue CHB],--Soma dos itens da NF q tem Tipo Taxa CHB  
  
  (case when isnull(TT.Tipo_Prod_Code,2) <> 1 then  
   sum(dbo.valor(Valor_ARP,DC))    
  end) [Gross Revenue Transp], --ambos e não chb    
     
  count(distinct CTA.Num_proc)JOBs,  
  month(Dt_Fatura) Mes  
 from   
  vwFaturasValidasArg CTA  with(nolock)  
  Join Tipo_Taxa TT   with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx  
  Join vwClienteALLJOBS hou with(nolock) on hou.Master=CTA.Num_Proc  
  Join Pessoa CLI    with(nolock) on HOU.cd_cliente=CLI.cd_pes  
  left Join Pessoa_LLP PLLP with(nolock) on HOU.cd_cliente=PLLP.cd_pes  
  left Join Pessoa PP   with(nolock) on PP.cd_pes=cd_pes_grupo      
 Where  
  --year(Dt_Fatura)=YEAR(getdate())  
  year(Dt_Fatura)=@year  
  and Dt_Fatura <=getdate()  
  --and month(dt_fatura) = @Mes  
  and (PP.Apelido = @Grupo or @Grupo  = 'ALL')      
 Group by   
  CLI.Nome_Raz_Soc,CLI.Apelido,PP.Apelido,HOU.Num_proc,  
  TT.Tipo_Prod_Code,Dt_Fatura  
  ,CTA.Num_proc,CTA.Cd_Tp_Tx,CTA.DC  
  
  
  
insert @resultadofinal(modal,grupo,empresa)  
 select distinct Modal,grupo,empresa from @ResultadoTemp  
   
insert @resultado(modal,grupo,empresa)  
 select distinct Modal,grupo,empresa from @ResultadoTemp  
   
  
  
--Janeiro  
insert @resultadofinal(modal,grupo,empresa,[Janeiro Gross Revenue Total],[Janeiro Gross Revenue CHB],  
[Janeiro Gross Revenue Transp],JaneiroJob)  
 select distinct RF.Modal,RT.grupo,RF.Empresa,SUM([Gross Revenue Total]),SUM([Gross Revenue CHB])  
 ,SUM([Gross Revenue Transp]),count (distinct JOB) from @Resultado RF  
 Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=1 and RT.Empresa=RF.Empresa  
 Group by RF.Modal,RT.grupo,RF.Empresa  
   
  
--Fevereiro  
insert @resultadofinal(modal,grupo,empresa,[Fevereiro Gross Revenue Total],[Fevereiro Gross Revenue CHB],[Fevereiro Gross Revenue Transp],FevereiroJOB)  
 select distinct RF.Modal,RT.grupo,RF.Empresa,SUM([Gross Revenue Total]),SUM([Gross Revenue CHB])  
 ,SUM([Gross Revenue Transp]),count (distinct JOB) from @Resultado RF  
 Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=2 and RT.Empresa=RF.Empresa  
 Group by RF.Modal,RT.grupo,RF.Empresa  
   
--Marco  
insert @resultadofinal(modal,grupo,empresa,[Marco Gross Revenue Total],[Marco Gross Revenue CHB],[Marco Gross Revenue Transp],MarcoJOB)  
 select distinct RF.Modal,RT.grupo,RF.Empresa,SUM([Gross Revenue Total]),SUM([Gross Revenue CHB])  
 ,SUM([Gross Revenue Transp]),count (distinct JOB)  from @Resultado RF  
 Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=3 and RT.Empresa=RF.Empresa  
 Group by RF.Modal,RT.grupo,RF.Empresa  
  
--Abril  
  
insert @resultadofinal(modal,grupo,empresa,[Abril Gross Revenue Total],[Abril Gross Revenue CHB],[Abril Gross Revenue Transp],AbrilJOB)  
 select distinct RF.Modal,RT.grupo,RF.Empresa,SUM([Gross Revenue Total]),SUM([Gross Revenue CHB])  
 ,SUM([Gross Revenue Transp]),count (distinct JOB)  from @Resultado RF  
 Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=4 and RT.Empresa=RF.Empresa  
 Group by RF.Modal,RT.grupo,RF.Empresa  
  
--Maio  
  
insert @resultadofinal(modal,grupo,empresa,[Maio Gross Revenue Total],[Maio Gross Revenue CHB],[Maio Gross Revenue Transp],MaioJOB)  
 select distinct RF.Modal,RT.grupo,RF.Empresa,SUM([Gross Revenue Total]),SUM([Gross Revenue CHB])  
 ,SUM([Gross Revenue Transp]),count (distinct JOB) from @Resultado RF  
 Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=5 and RT.Empresa=RF.Empresa  
 Group by RF.Modal,RT.grupo,RF.Empresa  
  
--Junho  
  
insert @resultadofinal(modal,grupo,empresa,[Junho Gross Revenue Total],[Junho Gross Revenue CHB],[Junho Gross Revenue Transp],JunhoJOB)  
 select distinct RF.Modal,RT.grupo,RF.Empresa,SUM([Gross Revenue Total]),SUM([Gross Revenue CHB])  
 ,SUM([Gross Revenue Transp]),count (distinct JOB) from @Resultado RF  
 Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=6 and RT.Empresa=RF.Empresa  
 Group by RF.Modal,RT.grupo,RF.Empresa  
   
--Julho  
  
insert @resultadofinal(modal,grupo,empresa,[Julho Gross Revenue Total],[Julho Gross Revenue CHB],[Julho Gross Revenue Transp],JulhoJOB)  
 select distinct RF.Modal,RT.grupo,RF.Empresa,SUM([Gross Revenue Total]),SUM([Gross Revenue CHB])  
 ,SUM([Gross Revenue Transp]),count (distinct JOB) from @Resultado RF  
 Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=7 and RT.Empresa=RF.Empresa  
 Group by RF.Modal,RT.grupo,RF.Empresa  
  
--Agosto  
  
insert @resultadofinal(modal,grupo,empresa,[Agosto Gross Revenue Total],[Agosto Gross Revenue CHB],[Agosto Gross Revenue Transp],AgostoJOB)  
 select distinct RF.Modal,RT.grupo,RF.Empresa,SUM([Gross Revenue Total]),SUM([Gross Revenue CHB])  
 ,SUM([Gross Revenue Transp]),count (distinct JOB) from @Resultado RF  
 Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=8 and RT.Empresa=RF.Empresa  
 Group by RF.Modal,RT.grupo,RF.Empresa  
  
--Setembro  
  
insert @resultadofinal(modal,grupo,empresa,[Setembro Gross Revenue Total],[Setembro Gross Revenue CHB],[Setembro Gross Revenue Transp],SetembroJOB)  
 select distinct RF.Modal,RT.grupo,RF.Empresa,SUM([Gross Revenue Total]),SUM([Gross Revenue CHB])  
 ,SUM([Gross Revenue Transp]),count (distinct JOB) from @Resultado RF  
 Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=9 and RT.Empresa=RF.Empresa  
 Group by RF.Modal,RT.grupo,RF.Empresa  
   
   
   
--Outubro  
  
insert @resultadofinal(modal,grupo,empresa,[Outubro Gross Revenue Total],[Outubro Gross Revenue CHB],[Outubro Gross Revenue Transp],OutubroJOB)  
 select distinct RF.Modal,RT.grupo,RF.Empresa,SUM([Gross Revenue Total]),SUM([Gross Revenue CHB])  
 ,SUM([Gross Revenue Transp]),count (distinct JOB) from @Resultado RF  
 Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=10 and RT.Empresa=RF.Empresa  
 Group by RF.Modal,RT.grupo,RF.Empresa  
  
--Novembro  
  
insert @resultadofinal(modal,grupo,empresa,[Novembro Gross Revenue Total],[Novembro Gross Revenue CHB],[Novembro Gross Revenue Transp],NovembroJOB)  
 select distinct RF.Modal,RT.grupo,RF.Empresa,SUM([Gross Revenue Total]),SUM([Gross Revenue CHB])  
 ,SUM([Gross Revenue Transp]),count (distinct JOB) from @Resultado RF  
 Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=11 and RT.Empresa=RF.Empresa  
 Group by RF.Modal,RT.grupo,RF.Empresa  
   
--Desembro  
  
insert @resultadofinal(modal,grupo,empresa,[Dezembro Gross Revenue Total],[Dezembro Gross Revenue CHB],[Dezembro Gross Revenue Transp],DezembroJob)  
 select distinct RF.Modal,RT.grupo,RF.Empresa,SUM([Gross Revenue Total]),SUM([Gross Revenue CHB])  
 ,SUM([Gross Revenue Transp]),count (distinct JOB) from @Resultado RF  
 Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=12 and RT.Empresa=RF.Empresa   
 Group by RF.Modal,RT.grupo,RF.Empresa  
  
select   
  Modal,  
  Grupo,  
  Empresa,  
  --Janeiro [Janeiro Value],  
  sum([Janeiro Gross Revenue Total])  [Janeiro Gross Revenue Total Value],  
  sum([Janeiro Gross Revenue CHB])  [Janeiro Gross Revenue CHB Value],  
  sum([Janeiro Gross Revenue Transp])  [Janeiro Gross Revenue Transp Value],  
  Sum(JaneiroJob) [Janeiro Number],  
  --Fevereiro [Fevereiro Value],  
  sum([Fevereiro Gross Revenue Total]) [Fevereiro Gross Revenue Total Value],  
  sum([Fevereiro Gross Revenue CHB])  [Fevereiro Gross Revenue CHB Value],  
  sum([Fevereiro Gross Revenue Transp]) [Fevereiro Gross Revenue Transp Value],  
  Sum(FevereiroJOB) [Fevereiro Number],  
  --Marco [Marco Value],  
  sum([Marco Gross Revenue Total])  [Marco Gross Revenue Total Value],  
  sum([Marco Gross Revenue CHB])   [Marco Gross Revenue CHB Value],  
  sum([Marco Gross Revenue Transp])  [Marco Gross Revenue Transp Value],  
  Sum(MarcoJOB) [Marco Number],  
  --Abril [Abril Value],  
  sum([Abril Gross Revenue Total])  [Abril Gross Revenue Total Value],  
  sum([Abril Gross Revenue CHB])   [Abril Gross Revenue CHB Value],  
  sum([Abril Gross Revenue Transp])  [Abril Gross Revenue Transp Value],  
  Sum(AbrilJOB) [Abril Number],  
  --Maio [Maio Value],  
  sum([Maio Gross Revenue Total])   [Maio Gross Revenue Total Value],  
  sum([Maio Gross Revenue CHB])   [Maio Gross Revenue CHB Value],  
  sum([Maio Gross Revenue Transp])  [Maio Gross Revenue Transp Value],  
  Sum(MaioJOB) [Maio Number],  
  --Junho [Junho Value],  
  sum([Junho Gross Revenue Total])  [Junho Gross Revenue Total Value],  
  sum([Junho Gross Revenue CHB])   [Junho Gross Revenue CHB Value],  
  sum([Junho Gross Revenue Transp])  [Junho Gross Revenue Transp Value],  
  Sum(JunhoJOB) [Junho Number],  
  --Julho [Julho Value],  
  sum([Julho Gross Revenue Total])  [Julho Gross Revenue Total Value],  
  sum([Julho Gross Revenue CHB])   [Julho Gross Revenue CHB Value],  
  sum([Julho Gross Revenue Transp])  [Julho Gross Revenue Transp Value],  
  Sum(JulhoJOB) [Julho Number],  
  --Agosto [Agosto Value],  
  sum([Agosto Gross Revenue Total])  [Agosto Gross Revenue Total Value],  
  sum([Agosto Gross Revenue CHB])   [Agosto Gross Revenue CHB Value],  
  sum([Agosto Gross Revenue Transp])  [Agosto Gross Revenue Transp Value],  
  Sum(AgostoJOB) [Agosto Number],  
  --Setembro [Setembro Value],  
  sum([Setembro Gross Revenue Total])  [Setembro Gross Revenue Total Value],  
  sum([Setembro Gross Revenue CHB])  [Setembro Gross Revenue CHB Value],  
  sum([Setembro Gross Revenue Transp]) [Setembro Gross Revenue Transp Value],  
  Sum(SetembroJOB) [Setembro Number],  
  --Outubro [Outubro Value],  
  sum([Outubro Gross Revenue Total])  [Outubro Gross Revenue Total Value],  
  sum([Outubro Gross Revenue CHB])  [Outubro Gross Revenue CHB Value],  
  sum([Outubro Gross Revenue Transp])  [Outubro Gross Revenue Transp Value],  
  Sum(OutubroJOB) [Outubro Number],  
  --Novembro [Novembro Value],  
  sum([Novembro Gross Revenue Total])  [Novembro Gross Revenue Total Value],  
  sum([Novembro Gross Revenue CHB])  [Novembro Gross Revenue CHB Value],  
  sum([Novembro Gross Revenue Transp]) [Novembro Gross Revenue Transp Value],  
  Sum(NovembroJOB) [Novembro Number],  
  --Dezembro [Dezembro Value],  
  sum([Dezembro Gross Revenue Total])  [Dezembro Gross Revenue Total Value],  
  sum([Dezembro Gross Revenue CHB])  [Dezembro Gross Revenue CHB Value],  
  sum([Dezembro Gross Revenue Transp]) [Dezembro Gross Revenue Transp Value],  
  Sum(DezembroJOB) [Dezembro Number]  
From  
  @ResultadoFinal  
Group by Modal,  
  Grupo,  
  Empresa  
    
  --,JaneiroJob,FevereiroJOB,MarcoJOB,  
  --AbrilJOB,MaioJOB,JunhoJOB,JulhoJOB,AgostoJOB,  
  --SetembroJOB,OutubroJOB,NovembroJOB,DezembroJOB  
    
    
/*  
  select   
  Modal,  
  Grupo,  
  Empresa,  
  --Janeiro [Janeiro Value],  
  [Janeiro Gross Revenue Total] ,  
  [Janeiro Gross Revenue CHB],  
  [Janeiro Gross Revenue Transp],  
  JaneiroJob [Janeiro Number],  
  --Fevereiro [Fevereiro Value],  
  [Fevereiro Gross Revenue Total] ,  
  [Fevereiro Gross Revenue CHB],  
  [Fevereiro Gross Revenue Transp],  
  FevereiroJOB [Fevereiro Number],  
  --Marco [Marco Value],  
  [Marco Gross Revenue Total] ,  
  [Marco Gross Revenue CHB],  
  [Marco Gross Revenue Transp],  
  MarcoJOB [Marco Number],  
  --Abril [Abril Value],  
  [Abril Gross Revenue Total] ,  
  [Abril Gross Revenue CHB],  
  [Abril Gross Revenue Transp],  
  AbrilJOB [Abril Number],  
  --Maio [Maio Value],  
  [Maio Gross Revenue Total] ,  
  [Maio Gross Revenue CHB],  
  [Maio Gross Revenue Transp],  
  MaioJOB [Maio Number],  
  --Junho [Junho Value],  
  [Junho Gross Revenue Total] ,  
  [Junho Gross Revenue CHB],  
  [Junho Gross Revenue Transp],  
  JunhoJOB [Junho Number],  
  --Julho [Julho Value],  
  [Julho Gross Revenue Total] ,  
  [Julho Gross Revenue CHB],  
  [Julho Gross Revenue Transp],  
  JulhoJOB [Julho Number],  
  --Agosto [Agosto Value],  
  [Agosto Gross Revenue Total] ,  
  [Agosto Gross Revenue CHB],  
  [Agosto Gross Revenue Transp],  
  AgostoJOB [Agosto Number],  
  --Setembro [Setembro Value],  
  [Setembro Gross Revenue Total] ,  
  [Setembro Gross Revenue CHB],  
  [Setembro Gross Revenue Transp],  
  SetembroJOB [Setembro Number],  
  --Outubro [Outubro Value],  
  [Outubro Gross Revenue Total] ,  
  [Outubro Gross Revenue CHB],  
  [Outubro Gross Revenue Transp],  
  OutubroJOB [Outubro Number],  
  --Novembro [Novembro Value],  
  [Novembro Gross Revenue Total] ,  
  [Novembro Gross Revenue CHB],  
  [Novembro Gross Revenue Transp],  
  NovembroJOB [Novembro Number],  
  --Dezembro [Dezembro Value],  
  [Dezembro Gross Revenue Total] ,  
  [Dezembro Gross Revenue CHB],  
  [Dezembro Gross Revenue Transp],  
  DezembroJOB [Dezembro Number]  
From  
  @ResultadoFinal*/  
GO
