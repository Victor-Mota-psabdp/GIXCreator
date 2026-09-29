SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--JOB	ID DA PO	Cd_Produto	Product id da PO	GROUP DA PO	Cd_tp_tx	NOME DA TAXA	Vlr_Item_Custo	Prestaca 

/* 
spIntegraCustoCliente_InsUpd 
'IMDPT201902102BR'
,274483
,''
,'D13869454'
,'GRUPO DUPONT'
,'XAD'
,'Taxas Siscomex - CHB'
,214.5
,'S'
go 
*/
 
CREATE Procedure [dbo].[spIntegraCustoCliente_InsUpd]
(
@Num_Proc			        Varchar(16),
@Cd_Pedido			         VarChar(30),
@Cd_Produto					 VarChar(30),
@Numero_PO				    VarChar(80),
@APELIDO				    VarChar(20),
@Cd_tp_tx					VarChar(3),
@Nome_Tp_Tx					VarChar(50),
@Vlr_Item_Custo			    decimal(10,2),
@Prestacao					char(1)
)
AS

set nocount on

CREATE TABLE INTEGRA_CUSTO
(
Num_Proc			        Varchar(16),
Cd_Pedido			         VarChar(30),
Cd_Produto					 VarChar(30),
Numero_PO				    VarChar(80),
APELIDO						VarChar(20),
Cd_tp_tx					VarChar(3),
Nome_Tp_Tx					VarChar(50),
Vlr_Item_Custo			    decimal(10,2),
Prestacao					char(1),
)

INSERT INTO INTEGRA_CUSTO
SELECT 
@Num_Proc,		
@Cd_Pedido,		
@Cd_Produto,		
@Numero_PO,		
@APELIDO,		
@Cd_tp_tx,			
@Nome_Tp_Tx,			
@Vlr_Item_Custo,		
@Prestacao	

--update INTEGRA_CUSTO
--set cd_produto = Numero_PO

UPDATE INTEGRA_CUSTO
SET cd_produto = pc.cd_prod 
from INTEGRA_CUSTO tmp
inner join Pessoa p
	on tmp.APELIDO = p.apelido
inner Join Produto_Cliente PC
	 ON tmp.Numero_PO = PC.Cd_Proc_Cliente
	 and p.cd_pes = PC.cd_cliente
	
insert into Custo_Cliente
select 
tmp.Num_Proc
,tmp.Cd_Pedido
,tmp.Cd_Produto
,tmp.Cd_tp_tx
,tmp.Vlr_Item_Custo
,null as Num_NF_Custo
,tmp.Prestacao
from INTEGRA_CUSTO tmp
left join Custo_Cliente cc
	on tmp.Num_Proc = cc.Num_Proc 
	and tmp.Cd_tp_tx = cc.Cd_tp_tx
where cc.Cd_tp_tx is null 

	
--select * from Custo_Cliente where Num_Proc = (select top 1 Num_Proc from INTEGRA_CUSTO)

--select cd_pes, * from Pessoa where Apelido = (select top 1 apelido from INTEGRA_CUSTO)

--SELECT 
--TMP.Num_Proc
--,TMP.Cd_Pedido
--,TMP.Cd_Produto
--,TMP.Cd_tp_tx
--,TMP.Vlr_Item_Custo
--,null as Num_NF_Custo
--,TMP.Prestacao
--,CC.*
--FROM Custo_Cliente CC
--INNER Join Pedido P on P.Cd_pedido = CC.Cd_Pedido
--inner Join Produto_Cliente PC on PC.cd_prod=CC.cd_produto
--inner Join Tipo_Taxa	TT on TT.Cd_Tp_Tx=CC.Cd_Tp_Tx
--INNER JOIN INTEGRA_CUSTO tmp
--	ON tmp.Numero_PO = PC.Cd_Proc_Cliente
--	--CC.Num_Proc='IMDPT201902102BR'

--select * from Custo_Cliente where Num_Proc=(select top 1 Num_Proc from INTEGRA_CUSTO)
--select * from Pedido where Cd_pedido = '274483'
--select Cd_Proc_Cliente,* from Produto_Cliente where cd_prod = '134026'

--select Cd_Proc_Cliente,* from Pedido where Cd_pedido = '274483'
--SELECT * FROM vwPO_ALL

drop table INTEGRA_CUSTO		

--Begin Transaction
--if exists(select Produto_Descr from Produto_Cliente where cd_Proc_Cliente = @GMID and Cd_Cliente=@Cd_Cliente)
--	BEGIN
--		if not exists(select gmid from DE_PARA_PRODUTO where gmid=@GMID and Cd_Cliente=@Cd_Cliente)
--			BEGIN
--				INSERT INTO 
--					DE_PARA_PRODUTO
--						(
--							Cd_Cliente, GMID, GMID_Descr_Curta, P_Descricao, S_Descricao, Business_Group_Code, 
--							Business_Group_Descr, Business_Code,Business_Descr,Value_Center_Code,Value_Center_Descr,
--							dt_ins,
--							Performance_Center_Code,Performance_Center_Descr
--						)
--				VALUES

--						(
--							@Cd_Cliente, @GMID, @GMID_Descr_Curta, @P_Descricao, @S_Descricao, @Business_Group_Code,
--							@Business_Group_Name, @Business_Code, @Business_Name, @Value_Center_Code, @Value_Center_Descr,
--							GETDATE(),
--							@Performance_Center_Code,@Performance_Center_Descr
--						)
--			END

--		ELSE
--			BEGIN
--				UPDATE
--					DE_PARA_PRODUTO
--						SET
--							--Cd_Cliente=@Cd_Cliente,
--							GMID_Descr_Curta=@GMID_Descr_Curta,
----							P_Descricao=@P_Descricao,
----							S_Descricao=@S_Descricao,
--							Value_Center_Code=@Value_Center_Code,
--							Value_Center_Descr=@Value_Center_Descr,
--							Business_Code=@Business_Code,
--							Business_Descr=@Business_Name,
--							Business_Group_Code=@Business_Group_Code,
--							Business_Group_Descr=@Business_Group_Name,
--							dt_ins = GETDATE(),
--							Performance_Center_Code= @Performance_Center_Code,
--							Performance_Center_Descr = @Performance_Center_Descr
--						WHERE
--							GMID=@GMID and Cd_Cliente=@Cd_Cliente
--			END
--	END
	
--	if @@Error<>0
--		BEGIN
--			ROLLBACK TRANSACTION
--			RETURN -1
--		END
--COMMIT TRANSACTION


GO
