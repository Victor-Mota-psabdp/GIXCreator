SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vwMAxLA_Sel]

as
select 
		MCC.num_lcto_mov [01_Mov Number],Num_Lcto_Rec [02_Financial Register],
		(case when concil_mov = 'S' then 'Closed' else 'Open' end) [03_Status],
		dc_mov [04_DC], convert(datetime,dt_pgto_Rcto_mov,103) [05_Mov Date], CC.titular [06_Bank Name], vlr_doc_mov [07_Mov Value], historico [08_Historic                    ]
	from 
		mvto_cta_cte MCC
		left join cta_cte CC on CC.Num_cta_cte=MCC.num_cta_cte
		left join Rec_cta_cte RCC on RCC.Num_Lcto_Mov=MCC.Num_Lcto_Mov
	where
		convert(datetime,dt_pgto_Rcto_mov,103) > getdate() -90

GO
