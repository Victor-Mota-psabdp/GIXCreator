SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spAnexoXVII_Sel]'IMSWB202107025BR' 

CREATE PROCEDURE [dbo].[spAnexoXVII_Sel]
(  
	@Num_Job VarChar(16)  
)  
AS  
  
  
declare @qtdeProduto as int  
set @qtdeProduto = (select count(distinct ps.cd_produto) from Pedido_Ship PS with(nolock)  
  join Pedido_Det PD with(nolock) on PD.Cd_Pedido = PS.Cd_Pedido and PD.Cd_Produto = PS.Cd_Produto and PD.item = PS.item  
  join Produto_Cliente PC with(nolock) on PS.Cd_Produto = PC.Cd_Prod  
  Left Join Produto_Perigoso PP with(nolock) on PP.cd_prod = PC.Cd_Prod   
  where   
   PS.Num_Proc = @Num_Job  
   and PP.uncode is not null  
   and PP.classCode is not null  
   and PP.HazMat_Name_Material is not null  
   and PP.HazMat_Description is not null)  
declare @tipoFechado as varchar(10)  
set @tipoFechado = (select top 1 JOB.Num_Proc from vwALL_JOBs JOB With(nolock)  
    JOIN dbo.Container_Hou_Imp_Mar AS HOU With(nolock) ON JOB.Num_Proc = HOU.Num_Proc_HIM  
    JOIN dbo.Container_Mas_Imp_Mar AS MAS With(nolock) ON HOU.Item_Cont_IM = MAS.Item_Cont_IM AND MAS.Num_Proc_MIM = HOU.Num_Proc_MIM  
    join Tipo_Container tc on tc.Cd_Tp_Cont = MAS.Cd_Tp_Cont  
   where Num_Proc = @Num_Job and TC.Cd_Tp_Cont in ('20F','20O','40F','40O','40T'))  
    
  
  
 Select distinct  
  Ship.Nome_Raz_Soc   Expedidor,  
  Ship.Nome_Raz_Soc   Expedidor_Nome,  
  Ship_End.Rua   Expedidor_Rua,  
  Ship_End.Cidade   Expedidor_Cidade,   
   
-- Alessandra 28/07/2021 100-287734
  --HAWB_HIM    Numero_Referencia,  
  HOU.MAWB_HIM	Numero_Referencia,
    
  Consig.Apelido    Consignatario,  
    
  ARM.Nome_Armador  Carrier,  
    
  Consig.Nome_Raz_Soc  Consignatario_Nome,  
  Consig.Num_CPF_CNPJ  Consignatario_CNPJ,  
  Consig_End.Rua   Consignatario_Rua,  
  Consig_End.Numero  Consignatario_Numero,  
  Consig_End.Cidade  Consignatario_Cidade,  
  Consig_End.UF   Consignatario_UF,  
  Consig_End.Bairro  Consignatario_Bairro,  
  Consig_End.CEP   Consignatario_CEP,  
    
  Navio_HIM     Navio,  
  Viagem_HIM     Viagem,  
    
  
  Orig.Nome_Local   Loading,  
  Destin.Nome_Local   Delivery,    
    
  Peso_Liquido_HIM,  
  Peso_Bruto_HIM,  
  --'ROBERTA KELLY BELTRAN' [USER],  
   --(case when PG.Apelido = 'GRUPO OXITENO' then 'CAMILA PEREIRA'  comentada por kaique 16/10/2024
  --  (case when PG.Apelido = 'GRUPO OXITENO' then 'DOUGLAS A. RODRIGUES'   
  -- ELSE  
  --(case when PG.Apelido = 'GRUPO FMC' or PG.Apelido = 'GRUPO DOW' or PG.Apelido = 'GRUPO SOLUTIA' or  
  --   PG.Apelido = 'GRUPO EASTMAN' or PG.Apelido = 'GRUPO TAMINCO' or PG.Apelido = 'GRUPO UPL DO BRASIL' or  
  --   --PG.Apelido = 'GRUPO ATANOR' then 'ROBERTA KELLY BELTRAN'  comentada por kaique 16/10/2024
	 --PG.Apelido = 'GRUPO ATANOR' then 'DOUGLAS DE ASSUNCAO RODRIGUES'  

  -- ELSE  
  --(Case when PG.Apelido = 'GRUPO GIVAUDAN' OR PG.Apelido = 'GRUPO GIVAUDAN AROMA' OR PG.Apelido = 'GRUPO SHERWIN'  OR PG.Apelido = 'GRUPO CORTEVA'
  -- --then 'ROSANGELA APARECIDA SILVA SANTOS' comentada por kaique 16/10/2024
  --  then 'DOUGLAS DE ASSUNCAO RODRIGUES' 
  -- ELSE  
  -- --'MARCIA SILVA' comentada por kaique 16/10/2024
  -- 'DOUGLAS DE ASSUNCAO RODRIGUES' 
  -- END) END) END)[USER],  
  
   convert(varchar(50), 'DOUGLAS DE ASSUNCAO RODRIGUES' )[USER],
  PG.Apelido Grupo,  
  --Obs_HIM,  
    
  --Descr.Header    Header,  
  convert(varchar(2000),'Material Name: ' + isnull(PP.HazMat_Name_Material,'')  + '|' +  
  'UN:' + isnull(PP.uncode,'') + '|' +   
  'Class Code:' + isnull(PP.classCode,'') + '|' +    
  'Description: ' + isnull(PP.HazMat_Description,''))  [Header],  
    
  --PP.HazMat_Description Header,  
  [dbo].[fBusca_Containers_IM_NUMERO_LACRE](HOU.Num_Proc_HIM) Containers,  
  [dbo].[fBusca_Volumes_QtyEmbal](HOU.Num_Proc_HIM) Volumes,  
  (case when LLP.Cd_Tp_Carga = 3 then 'Embalagens para Graneis'   
   else  
   (case when @qtdeProduto > 1 then 'Carga Heterogênea'  
   else  
    'Carga Homogênea'end)end) Carga,  
  
  --select * from vwAnexoVII_Mercadorias_Sel  
  --isnull(V176.Carga,'Carga Homogênea') Carga,  
    
  --select * from vwAnexoVII_Tipo_Carga_Sel  
  (case when @tipoFechado <> '' then 'Aberto' else 'Fechado' end) Tipo  
  --isnull(V177.Carga,'Container Fechado') Tipo  
    
 From    
  House_Imp_Mar  HOU with(nolock)  
  Join Job_Imp_Mar  JOB   with(nolock) on HOU.Num_Proc_HIM  = JOB.Num_Proc_HIM  
  Join LLP_Imp_Mar  LLP   with(nolock) on HOU.Num_Proc_HIM = LLP.Num_Proc_Lim  
  Join Pessoa   Ship  with(nolock) on Cd_Export_HIM  = Ship.Cd_Pes    
  Join Endereco  Ship_End with(nolock) on Ship_End.Cd_Pes  = Ship.Cd_Pes  and Ship_End.cd_tp_end = 'COM'
    
  Join Pessoa   Consig  with(nolock) on Cd_Consig_HIM  = Consig.Cd_Pes   
  Left join Pessoa_LLP   PL with(nolock) on Cd_Consig_HIM = PL.Cd_Pes  
  Left Join  Grupo    G with(nolock) on G.cd_pes_grupo=PL.cd_pes_grupo  
  Left Join  pessoa    PG with(nolock) on PG.cd_pes=PL.Cd_Pes_Grupo  
  Left Outer Join Endereco  Consig_End with(nolock) on Consig_End.Cd_Pes = Consig.Cd_Pes  and Consig_End.cd_tp_end = 'COM'
    
  Join Localidade  Orig  with(nolock) on Cd_Org_HIM   = Orig.Cd_Local   
  join Localidade  Destin  with(nolock) on Cd_Dst_HIM   = Destin.Cd_Local   
  Left Outer Join Armador   ARM   with(nolock) on JOB.Cd_Armador = Arm.Cd_Armador 
    
  Left Outer Join Pessoa   CHB   with(nolock) on Cd_Despachante = CHB.Cd_Pes  
  
  Left Outer Join Localidade  Origin  with(nolock) on Cd_Planta_Lim  = Origin.Cd_Local  
  Left Outer Join Localidade  DstFinal with(nolock) on Cd_DstFinal_LIM  = DstFinal.Cd_Local  
    
  join Pedido_Ship				PS  with(nolock) on HOU.num_proc_him = PS.num_proc  
  join Pedido					P with(nolock) on P.cd_pedido = PS.cd_pedido
  join Pedido_Det				PD  with(nolock) on PD.Cd_Pedido = PS.Cd_Pedido and PD.Cd_Produto = PS.Cd_Produto and PD.item = PS.item and PD.lote = PS.lote
  join Produto_Cliente			PC  with(nolock) on PS.Cd_Produto = PC.Cd_Prod  and PC.cd_cliente=  p.cd_grupo
  Left Join Produto_Perigoso	PP  with(nolock) on PP.cd_prod = PC.Cd_Prod    
 Where  
  HOU.Num_Proc_HIM = @Num_Job  
  and PP.uncode is not null  
  and PP.classCode is not null  
  and PP.HazMat_Name_Material is not null  
  and PP.HazMat_Description is not null  
    
  
  
  
  
  
  
--Cd_tp_cont Nome_tp_Cont   
--20B 20ft - Box Fechado  
--20D 20ft - Dry Van Fechado  
--20H 20ft - High Cube Fechado  
--20R 20ft - Reefer Fechado  
--20T 20ft - ISO Tank Fechado  
--2LP 20ft - Flexitank Fechado  
--40B 40ft - Box Fechado  
--40D 40ft - Dry Van Fechado  
--40H 40ft - High Cube Fechado  
--40I 40ft - ISO TANK Fechado  
--40N 40ft - NOR Fechado  
--40R 40ft - Reefer Fechado  
  
  
--20F 20ft - Flat Rack Aberto  
--20O 20ft - Open Top Aberto  
--40F 40ft - Flat Rack Aberto  
--40O 40ft - Open Top Aberto  
--40T 40ft - OpenTop HCube Aberto  





--SELECT * FROM Produto_Perigoso WHERE CD_PROD = 124390  
--SELECT * FROM Pedido_Ship WHERE num_proc = 'IMOXT201712044BR'  
  
--ALTER PROCEDURE [dbo].[spAnexoXVII_Sel]--'IMOXT201712044BR'  
--(  
-- @Num_Job VarChar(16)  
--)  
--AS  
  
  
--declare @qtdeProduto as int  
--set @qtdeProduto = (select count(distinct ps.cd_produto) from Pedido_Ship PS with(nolock)  
--  join Pedido_Det PD with(nolock) on PD.Cd_Pedido = PS.Cd_Pedido and PD.Cd_Produto = PS.Cd_Produto and PD.item = PS.item  
--  join Produto_Cliente PC with(nolock) on PS.Cd_Produto = PC.Cd_Prod  
--  Left Join Produto_Perigoso PP with(nolock) on PP.cd_prod = PC.Cd_Prod   
--  where   
--   PS.Num_Proc = @Num_Job  
--   and PP.uncode is not null  
--   and PP.classCode is not null  
--   and PP.HazMat_Name_Material is not null  
--   and PP.HazMat_Description is not null)  
--declare @tipoFechado as varchar(10)  
--set @tipoFechado = (select top 1 JOB.Num_Proc from vwALL_JOBs JOB With(nolock)  
--    JOIN dbo.Container_Hou_Imp_Mar AS HOU With(nolock) ON JOB.Num_Proc = HOU.Num_Proc_HIM  
--    JOIN dbo.Container_Mas_Imp_Mar AS MAS With(nolock) ON HOU.Item_Cont_IM = MAS.Item_Cont_IM AND MAS.Num_Proc_MIM = HOU.Num_Proc_MIM  
--    join Tipo_Container tc on tc.Cd_Tp_Cont = MAS.Cd_Tp_Cont  
--   where Num_Proc = @Num_Job and TC.Cd_Tp_Cont in ('20F','20O','40F','40O','40T'))  
    
  
  
-- Select distinct  
--  Ship.Nome_Raz_Soc   Expedidor,  
--  Ship.Nome_Raz_Soc   Expedidor_Nome,  
--  Ship_End.Rua   Expedidor_Rua,  
--  Ship_End.Cidade   Expedidor_Cidade,   
   
---- Alessandra 28/07/2021 100-287734
--  --HAWB_HIM    Numero_Referencia,  
--  HOU.MAWB_HIM	Numero_Referencia,
    
--  Consig.Apelido    Consignatario,  
    
--  ARM.Nome_Armador  Carrier,  
    
--  Consig.Nome_Raz_Soc  Consignatario_Nome,  
--  Consig.Num_CPF_CNPJ  Consignatario_CNPJ,  
--  Consig_End.Rua   Consignatario_Rua,  
--  Consig_End.Numero  Consignatario_Numero,  
--  Consig_End.Cidade  Consignatario_Cidade,  
--  Consig_End.UF   Consignatario_UF,  
--  Consig_End.Bairro  Consignatario_Bairro,  
--  Consig_End.CEP   Consignatario_CEP,  
    
--  Navio_HIM     Navio,  
--  Viagem_HIM     Viagem,  
    
  
--  Orig.Nome_Local   Loading,  
--  Destin.Nome_Local   Delivery,    
    
--  Peso_Liquido_HIM,  
--  Peso_Bruto_HIM,  
--  --'ROBERTA KELLY BELTRAN' [USER],  
--  (case when PG.Apelido = 'GRUPO OXITENO' then 'CAMILA PEREIRA'   
--   ELSE  
--  (case when PG.Apelido = 'GRUPO FMC' or PG.Apelido = 'GRUPO DOW' or PG.Apelido = 'GRUPO SOLUTIA' or  
--     PG.Apelido = 'GRUPO EASTMAN' or PG.Apelido = 'GRUPO TAMINCO' or PG.Apelido = 'GRUPO UPL DO BRASIL' or  
--     PG.Apelido = 'GRUPO ATANOR' then 'ROBERTA KELLY BELTRAN'  
--   ELSE  
--  (Case when PG.Apelido = 'GRUPO GIVAUDAN' OR PG.Apelido = 'GRUPO GIVAUDAN AROMA' OR PG.Apelido = 'GRUPO SHERWIN'  OR PG.Apelido = 'GRUPO CORTEVA'
--   then 'ROSANGELA APARECIDA SILVA SANTOS'   
--   ELSE  
--   'MARCIA SILVA'  
--   END) END) END)[USER],  
--  PG.Apelido Grupo,  
--  --Obs_HIM,  
    
--  --Descr.Header    Header,  
--  convert(varchar(2000),'Material Name: ' + isnull(PP.HazMat_Name_Material,'')  + '|' +  
--  'UN:' + isnull(PP.uncode,'') + '|' +   
--  'Class Code:' + isnull(PP.classCode,'') + '|' +    
--  'Description: ' + isnull(PP.HazMat_Description,''))  [Header],  
    
--  --PP.HazMat_Description Header,  
--  [dbo].[fBusca_Containers_IM_NUMERO_LACRE](HOU.Num_Proc_HIM) Containers,  
--  [dbo].[fBusca_Volumes_QtyEmbal](HOU.Num_Proc_HIM) Volumes,  
--  (case when LLP.Cd_Tp_Carga = 3 then 'Embalagens para Graneis'   
--   else  
--   (case when @qtdeProduto > 1 then 'Carga Heterogênea'  
--   else  
--    'Carga Homogênea'end)end) Carga,  
  
--  --select * from vwAnexoVII_Mercadorias_Sel  
--  --isnull(V176.Carga,'Carga Homogênea') Carga,  
    
--  --select * from vwAnexoVII_Tipo_Carga_Sel  
--  (case when @tipoFechado <> '' then 'Aberto' else 'Fechado' end) Tipo  
--  --isnull(V177.Carga,'Container Fechado') Tipo  
    
-- From    
--  House_Imp_Mar  HOU with(nolock)  
--  Left Outer Join Job_Imp_Mar  JOB   with(nolock) on HOU.Num_Proc_HIM  = JOB.Num_Proc_HIM  
--  Left Outer Join LLP_Imp_Mar  LLP   with(nolock) on HOU.Num_Proc_HIM = LLP.Num_Proc_Lim  
--  Left Outer Join Pessoa   Ship  with(nolock) on Cd_Export_HIM  = Ship.Cd_Pes    
--  Left Outer Join Endereco  Ship_End with(nolock) on Ship_End.Cd_Pes  = Ship.Cd_Pes  
    
--  Left Outer Join Pessoa   Consig  with(nolock) on Cd_Consig_HIM  = Consig.Cd_Pes   
--  Left join Pessoa_LLP   PL with(nolock) on Cd_Consig_HIM = PL.Cd_Pes  
--  Left Join  Grupo    G with(nolock) on G.cd_pes_grupo=PL.cd_pes_grupo  
--  Left Join  pessoa    PG with(nolock) on PG.cd_pes=PL.Cd_Pes_Grupo  
--  Left Outer Join Endereco  Consig_End with(nolock) on Consig_End.Cd_Pes = Consig.Cd_Pes  
    
--  Left Outer Join Localidade  Orig  with(nolock) on Cd_Org_HIM   = Orig.Cd_Local   
--  Left Outer Join Localidade  Destin  with(nolock) on Cd_Dst_HIM   = Destin.Cd_Local   
--  Left Outer Join Armador   ARM   with(nolock) on JOB.Cd_Armador = Arm.Cd_Armador  
    
    
--  Left Outer Join Pessoa   CHB   with(nolock) on Cd_Despachante = CHB.Cd_Pes  
  
--  Left Outer Join Localidade  Origin  with(nolock) on Cd_Planta_Lim  = Origin.Cd_Local  
--  Left Outer Join Localidade  DstFinal with(nolock) on Cd_DstFinal_LIM  = DstFinal.Cd_Local  
    
--  join Pedido_Ship     PS  with(nolock) on HOU.num_proc_him = PS.num_proc  
--  join Pedido_Det      PD  with(nolock) on PD.Cd_Pedido = PS.Cd_Pedido and PD.Cd_Produto = PS.Cd_Produto and PD.item = PS.item  
--  join Produto_Cliente    PC  with(nolock) on PS.Cd_Produto = PC.Cd_Prod  
--  Left Outer Join Produto_Perigoso PP  with(nolock) on PP.cd_prod = PC.Cd_Prod  
  
--  --Left Outer Join Campo_Processo CP176 with(nolock)  on HOU.Num_proc_him  = CP176.Num_Proc  and CP176.Id_Campo = 176  
--  --Left Outer Join vwAnexoVII_Mercadorias_Sel v176 with(nolock) on v176.code  = CP176.Campo_Dados  
--  --Left Outer Join Campo_Processo CP177 with(nolock)  on HOU.Num_proc_him  = CP177.Num_Proc and CP177.Id_Campo = 177  
--  --Left Outer Join vwAnexoVII_Tipo_Carga_Sel v177 with(nolock) on v177.code  = CP177.Campo_Dados  
  
-- Where  
--  HOU.Num_Proc_HIM = @Num_Job  
--  and PP.uncode is not null  
--  and PP.classCode is not null  
--  and PP.HazMat_Name_Material is not null  
--  and PP.HazMat_Description is not null  
    
  
  
  
  
  
  
----Cd_tp_cont Nome_tp_Cont   
----20B 20ft - Box Fechado  
----20D 20ft - Dry Van Fechado  
----20H 20ft - High Cube Fechado  
----20R 20ft - Reefer Fechado  
----20T 20ft - ISO Tank Fechado  
----2LP 20ft - Flexitank Fechado  
----40B 40ft - Box Fechado  
----40D 40ft - Dry Van Fechado  
----40H 40ft - High Cube Fechado  
----40I 40ft - ISO TANK Fechado  
----40N 40ft - NOR Fechado  
----40R 40ft - Reefer Fechado  
  
  
----20F 20ft - Flat Rack Aberto  
----20O 20ft - Open Top Aberto  
----40F 40ft - Flat Rack Aberto  
----40O 40ft - Open Top Aberto  
----40T 40ft - OpenTop HCube Aberto  
GO
