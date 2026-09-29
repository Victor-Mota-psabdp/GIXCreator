SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spMaster_Pesos_Upd] --'IMSSZ200906022', 'IMWAL20090102501'
	@Master		VarChar(14)
AS

Begin Transaction

	If left(UPPER(@Master),2) = 'IM'
		Begin
		--Tabela Master_Imp_Mar
			Update
				Master_Imp_Mar
			Set
				Vol_Tot_MIM		= (select sum(Vol_Tot_HIM)    from House_Imp_Mar where Num_Proc_MIM=@Master group by Num_Proc_MIM),
				Peso_Bruto_MIM	= (select sum(Peso_Bruto_HIM) from House_Imp_Mar where Num_Proc_MIM=@Master group by Num_Proc_MIM)
			Where
				Num_Proc_MIM = @Master
		--Tabela LLP_Master
			Update
				LLP_Master
			Set
				Peso_Liquido = (select sum(Peso_Liquido_HIM) from House_Imp_Mar where Num_Proc_MIM=@Master group by Num_Proc_MIM)
			Where
				Num_Proc_Master = @Master
		end

	ELSE IF left(UPPER(@Master),2) = 'IA'
		Begin
		--Tabela Master_Imp_aer
			Update
				Master_Imp_Aer
			Set
				Peso_Bruto_MIA	= (select sum(Peso_Bruto_HIA) from House_Imp_Aer where Num_Proc_MIA=@Master group by Num_Proc_MIA),
				Qtd_Tot_Vol_MIA	= (select sum(qtd_tot_vol_hia) from House_Imp_Aer where Num_Proc_MIA=@Master group by Num_Proc_MIA)				
			Where
				Num_Proc_MIA = @Master
		--Tabela LLP_Master
			Update
				LLP_Master
			Set
				Peso_Liquido = (select sum(Peso_Real_HIA) from House_Imp_Aer where Num_Proc_MIA=@Master group by Num_Proc_MIA),
				Peso_Cubado =  (select sum(Peso_Cubado_LIA) from LLP_Imp_Aer where Num_Proc_LIA in ((select Num_Proc_HIA from House_Imp_Aer where Num_Proc_MIA=@Master)))
			Where
				Num_Proc_Master = @Master
		end

	ELSE If left(UPPER(@Master),2) = 'EM'
		Begin
		--Tabela Master_Exp_Mar
			Update
				Master_Exp_Mar
			Set
				Vol_Tot_MEM		= (select sum(Vol_Tot_HEM)    from House_Exp_Mar where Num_Proc_MEM=@Master group by Num_Proc_MEM),
				Peso_Bruto_MEM	= (select sum(Peso_Bruto_HEM) from House_Exp_Mar where Num_Proc_MEM=@Master group by Num_Proc_MEM)
			Where
				Num_Proc_MEM = @Master
		--Tabela LLP_Master
			Update
				LLP_Master
			Set
				Peso_Liquido = (select sum(Peso_Liquido_HEM) from House_Exp_Mar where Num_Proc_MEM=@Master group by Num_Proc_MEM)
			Where
				Num_Proc_Master = @Master
		end

	ELSE IF left(UPPER(@Master),2) = 'EA'
		Begin
		--Tabela Master_Exp_Mar
			Update
				Master_Exp_Aer
			Set
				Vol_Tot_MEA = (select sum(Vol_Tot_HEA)    from House_Exp_AER where Num_Proc_MEA=@Master group by Num_Proc_MEA),
				Peso_Bruto_MEA	= (select sum(Peso_Bruto_HEA) from House_Exp_Aer where Num_Proc_MEA=@Master group by Num_Proc_MEA),
				Qtd_Tot_Vol_MEA	= (select sum(qtd_tot_vol_hea) from House_Exp_Aer where Num_Proc_MEA=@Master group by Num_Proc_MEA)
			Where
				Num_Proc_MEA = @Master
		--Tabela LLP_Master
			Update
				LLP_Master
			Set
				Peso_Liquido = (select sum(Peso_Real_HEA) from House_Exp_Aer where Num_Proc_MEA=@Master group by Num_Proc_MEA)
				--Peso_Cubado =  (select sum(Peso_Cubado_LEA) from LLP_Exp_Aer where Num_Proc_LEA in ((select Num_Proc_HEA from House_Exp_Aer where Num_Proc_MEA=@Master)))
			Where
				Num_Proc_Master = @Master
		end



	IF @@Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END

Commit Transaction 














































GO
