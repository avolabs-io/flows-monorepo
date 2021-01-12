import React, { useState } from "react";

const paragraph =
  "Lorem ipsum dolor sit amet consectetur adipisicing elit. Eveniet natus sint provident vel ab reprehenderit cum soluta, suscipit facere nisi sed earum repellendus fuga debitis, nam molestiae minima voluptates possimus.";

const data = [
  {
    title: "What is a payment stream?",
    paragraph: paragraph,
  },
  {
    title: "How do I create a stream?",
    paragraph: paragraph,
  },
  {
    title: "faq 3",
    paragraph: paragraph,
  },
  {
    title: "faq 4",
    paragraph: paragraph,
  },
];

const Accordion = () => {
  return (
    <div className="wrapper">
      <ul className="accordion-list">
        {data.map((data, key) => {
          return (
            <li className="accordion-list__item" key={key}>
              <AccordionItem {...data} />
            </li>
          );
        })}
      </ul>
    </div>
  );
};

const AccordionItem = ({ title, paragraph }) => {
  const [opened, setOpened] = useState(false);

  return (
    <div
      className={`accordion-item, ${opened && "accordion-item--opened"}`}
      onClick={() => {
        setOpened(!opened);
      }}
    >
      <div className="accordion-item__line">
        <h3 className="accordion-item__title">{title}</h3>
        <span className="accordion-item__icon" />
      </div>
      <div className="accordion-item__inner">
        <div className="accordion-item__content">
          <p className="accordion-item__paragraph">{paragraph}</p>
        </div>
      </div>
    </div>
  );
};

export default Accordion;
