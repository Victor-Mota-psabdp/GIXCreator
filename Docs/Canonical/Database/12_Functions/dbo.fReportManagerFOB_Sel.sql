SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Function [dbo].[fReportManagerFOB_Sel]
	(
	@Num_Proc	Varchar(16),
	@Cd_Produto	varchar(30)
	)

returns 
	float

as

Begin
Return(
select 	top 1 (	Select Case Upper(Tipo_Unid)
			When 'KG' THEN Preco_Unit*sum(Peso_Liquido)
			ELSE Preco_Unit*sum(quantidade)*capacidade 
		END
	)

	from invoice_det ID
Join Invoice_Cliente IC on IC.id_inv=ID.id_inv
Join Produto_Cliente PC on PC.cd_prod=ID.cd_produto
Where
	Num_PRoc=@Num_Proc and Cd_proc_cliente like @Cd_Produto
group by
	cd_proc_cliente,Preco_Unit,Peso_Liquido,Tipo_Unid,Num_Proc ,capacidade

)
End
GO
