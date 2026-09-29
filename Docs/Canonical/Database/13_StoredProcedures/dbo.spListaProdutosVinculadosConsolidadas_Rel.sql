SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Incluir Modais e Export 13/07/2010 - Camilla

CREATE procedure [dbo].[spListaProdutosVinculadosConsolidadas_Rel] --'IACAR20100700301'
(
@job as varchar(16)
)
as 

--House e Master Imp Mar
select 
       HOU.num_proc_him [Job], PS.item [Item] , PC.cd_proc_cliente [Cod. Produto], PC.NCM_Cliente [NCM], PS.qty [Quantidade], PC.Produto_Descr [Descrição do Produto]
from 
      house_imp_mar HOU
      left join pedido_ship PS on PS.num_proc=HOU.num_proc_him
      left join produto_cliente PC on PC.cd_prod=PS.cd_produto
where
      ((Num_Proc_MIM = @job) or (Num_Proc_Him = @job))
UNION

-- House e Master Imp Aer
select 
       HOU.num_proc_hia job, PS.item item , PC.cd_proc_cliente cod_produto, PC.NCM_Cliente ncm, PS.qty qty, PC.Produto_Descr
from 
      house_imp_aer HOU
      left join pedido_ship PS on PS.num_proc=HOU.num_proc_hia
      left join produto_cliente PC on PC.cd_prod=PS.cd_produto
where
      ((Num_Proc_MIA = @job) or (Num_Proc_Hia = @job))
UNION

--House Imp Out
select 
       HOU.num_proc_hio job, PS.item item , PC.cd_proc_cliente cod_produto, PC.NCM_Cliente ncm, PS.qty qty, PC.Produto_Descr
from 
      house_imp_out HOU
      left join pedido_ship PS on PS.num_proc=HOU.num_proc_hio
      left join produto_cliente PC on PC.cd_prod=PS.cd_produto
where
      Num_Proc_Hio = @job
UNION

--House e Master Export Mar
select 
       HOU.num_proc_hem job, PS.item item , PC.cd_proc_cliente cod_produto, PC.NCM_Cliente ncm, PS.qty qty, PC.Produto_Descr
from 
      house_exp_mar HOU
      left join pedido_ship PS on PS.num_proc=HOU.num_proc_hem
      left join produto_cliente PC on PC.cd_prod=PS.cd_produto
where
      ((Num_Proc_MEM = @job) or (Num_Proc_Hem = @job))
UNION

--House e Master Export Aer
select 
       HOU.num_proc_hea job, PS.item item , PC.cd_proc_cliente cod_produto, PC.NCM_Cliente ncm, PS.qty qty, PC.Produto_Descr
from 
      house_exp_aer HOU
      left join pedido_ship PS on PS.num_proc=HOU.num_proc_hea
      left join produto_cliente PC on PC.cd_prod=PS.cd_produto
where
      ((Num_Proc_MEA = @job) or (Num_Proc_Hea = @job))
UNION

--House Export Out
select 
       HOU.num_proc_heo job, PS.item item , PC.cd_proc_cliente cod_produto, PC.NCM_Cliente ncm, PS.qty qty, PC.Produto_Descr
from 
      house_exp_out HOU
      left join pedido_ship PS on PS.num_proc=HOU.num_proc_heo
      left join produto_cliente PC on PC.cd_prod=PS.cd_produto
where
      Num_Proc_Heo = @job

order by
     job

GO
